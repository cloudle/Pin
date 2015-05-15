Wings.Document.register 'products', 'Product', class Product
  @insert: (doc, callback) -> @document.insert doc, callback
  @transform: (doc) ->
    return unless typeof doc.units is "object" or typeof doc.prices is "object"

    if doc.units.length is 0
      doc.insertBaseUnit = (option, callback) ->
        return unless typeof option is "object"
        if option.name
          unit  = {_id: Random.id(), name: option.name, conversion: 1, isBase: true, allowDelete: false}

          price = { unit: unit._id, isBase: true}
          price.sale   = option.salePrice if option.salePrice > 0
          price.import = option.importPrice if option.importPrice > 0

          Document.Product.update doc._id, {$push: {units: unit, prices: price}}, callback
    else
      doc.useAdvancePrice = true
      doc.productUnits = []
      for unit, index in doc.units
        doc.productUnits.push(_.clone(unit))
        listPrices = _.where(doc.prices, {unit: unit._id})
        branchPrice = _.findWhere(listPrices, {unit: unit._id}) #them id cua Branch
        basePrice   = _.findWhere(listPrices, {unit: unit._id})

        doc.productUnits[index].unitIndex = index
        doc.productUnits[index].unitName  = doc.productUnits[index].name
        doc.productUnits[index].name      = doc.name

        if branchPrice
          doc.productUnits[index].priceId     = branchPrice._id
          doc.productUnits[index].priceIndex  = _.indexOf(doc.prices, branchPrice)
          doc.productUnits[index].salePrice   = branchPrice.sale
          doc.productUnits[index].importPrice = branchPrice.import
        else if basePrice
          doc.productUnits[index].priceId     = basePrice._id
          doc.productUnits[index].priceIndex  = _.indexOf(doc.prices, basePrice)
          doc.productUnits[index].salePrice   = basePrice.sale
          doc.productUnits[index].importPrice = basePrice.import

        if unit.isBase
          doc.unitIndex    = index
          doc.priceIndex   = index
          doc.baseUnit     = unit._id
          doc.baseUnitName = unit.name
          doc.barcode      = unit.barcode
          doc.salePrice    = doc.productUnits[index].salePrice
          doc.importPrice  = doc.productUnits[index].importPrice

          if branchPrice then doc.priceIndex = _.indexOf(doc.prices, branchPrice)
          else if basePrice then doc.priceIndex = _.indexOf(doc.prices, basePrice)
      productUnit.baseUnitName = doc.baseUnitName for productUnit, index in doc.productUnits


      doc.updateBaseUnit = (option, callback) ->
        return unless typeof option is "object"
        updateBaseUnitQuery = {$set:{}}

        if option.name and !_.contains(_.pluck(doc.units, 'name'), option.name)
          updateBaseUnitQuery.$set["units."+doc.unitIndex+".name"] = option.name

        if (option.salePrice and option.salePrice >= 0) or (option.importPrice and option.importPrice >= 0)
          updateBaseUnitQuery.$set["prices."+doc.priceIndex+".sale"]   = option.salePrice
          updateBaseUnitQuery.$set["prices."+doc.priceIndex+".import"] = option.importPrice

        Document.Product.update(doc._id, updateBaseUnitQuery, callback) unless _.isEmpty(updateBaseUnitQuery.$set)

      doc.insertUnit = (option, callback) ->
        return unless typeof option is "object"
        if option.name and !_.contains(_.pluck(doc.units, 'name'), option.name)
          unit            = {_id: Random.id(), name: option.name, conversion: 1}
          unit.conversion = option.conversion if option.conversion > 1

          price = { unit: unit._id}
          price.sale   = option.salePrice if option.salePrice > 0
          price.import = option.importPrice if option.importPrice > 0

          console.log price

          Document.Product.update doc._id, {$push: {units: unit, prices: price}}, callback

      doc.updateUnit = (option, callback) ->
        return unless typeof option is "object"
        return unless unitFound = _.findWhere(doc.productUnits, {_id: option.id})

        updateBaseUnitQuery = {$set:{}}
        nameLists = _.pluck(doc.units, 'name')
        nameLists = _.without(nameLists, unitFound.name)

        if option.name and !_.contains(nameLists, option.name)
          updateBaseUnitQuery.$set["units."+unitFound.unitIndex+".name"] = option.name
          Document.Product.update doc._id, updateBaseUnitQuery, callback

        if (option.salePrice and option.salePrice >= 0) or (option.importPrice and option.importPrice >= 0)
          updateBaseUnitQuery.$set["prices."+unitFound.priceIndex+".sale"]   = option.salePrice
          updateBaseUnitQuery.$set["prices."+unitFound.priceIndex+".import"] = option.importPrice

        Document.Product.update(doc._id, updateBaseUnitQuery, callback) unless _.isEmpty(updateBaseUnitQuery.$set)

      doc.removeUnit = (id, callback) ->
        return unless typeof id is "string"
        unitFound = _.findWhere(doc.productUnits, {_id: id})
        if unitFound.allowDelete
          removeUnitQuery = {$pull:{}}
          removeUnitQuery.$pull.units  = doc.units[unitFound.unitIndex]
          removeUnitQuery.$pull.prices = doc.prices[unitFound.priceIndex]
          Document.Product.update(doc._id, removeUnitQuery, callback)

Document.Product.attachSchema new SimpleSchema
  name:
    type: String
    index: 1
    unique: true

  description:
    type: String
    optional: true

  image:
    type: String
    optional: true

  imports:
    type: [String]
    optional: true

  sales:
    type: [String]
    optional: true

  returns:
    type: [String]
    optional: true

  creator   : Schema.creator
  slug      : Schema.slugify('Product')
  version   : { type: Schema.version }



  units: type: [Object], defaultValue: []
  'units.$._id'        : Schema.uniqueId
  'units.$.barcode'    : Schema.barcode
  'units.$.name'       : type: String
  'units.$.conversion' : type: Number
  'units.$.isBase'     : Schema.defaultBoolean()
  'units.$.allowDelete': Schema.defaultBoolean(true)
  'units.$.createdAt'  : Schema.defaultCreatedAt


  prices           : type: [Object], defaultValue: []
  'prices.$.branch': type: String  , optional: true
  'prices.$.unit'  : type: String
  'prices.$.isBase': Schema.defaultBoolean()
  'prices.$.sale'  : Schema.defaultNumber()
  'prices.$.import': Schema.defaultNumber()


  nameHistories:
    type: [Object]
    optional: true
    autoValue: ->
      unit = @field('units'); name = @field('name'); description = @field('description')
      if name.value and _.isEmpty(unit.value)
        return [{date: new Date, content: name.value, name: true}]
      else
        if !_.isEmpty(unit.value) and unit.value._id
          return {$push:{date: new Date, content: unit.value.name, unit: unit.value._id}}
        else if name.value
          return {$push : {date: new Date, content: name.value, name: true}}
        else
          @unset()
          return
  'nameHistories.$.name'        : type: Boolean, optional: true
  'nameHistories.$.unit'        : type: String , optional: true
  'nameHistories.$.date'        : type: Date   , optional: true
  'nameHistories.$.content'     : type: String , optional: true


  qualities                        : type: [Object], defaultValue: []
  'qualities.$.branch'             : type: String  , optional: true
  'qualities.$.availableQuality'   : Schema.defaultNumber()
  'qualities.$.inOderQuality'      : Schema.defaultNumber()
  'qualities.$.inStockQuality'     : Schema.defaultNumber()
  'qualities.$.saleQuality'        : Schema.defaultNumber()
  'qualities.$.returnSaleQuality'  : Schema.defaultNumber()
  'qualities.$.importQuality'      : Schema.defaultNumber()
  'qualities.$.returnImportQuality': Schema.defaultNumber()

#
#  useVariant:
#    type: Boolean
#    defaultValue: false
#
#  variantChoices:
#    type: [Schema.productVariantChoices]
#    optional: true
#
#  extracts:
#    type: [Schema.productExtract]
#    optional: true

#Module "Schema",
#  productUnit: new SimpleSchema
#    _id         : Schema.uniqueId
#    barcode     : Schema.barcode
#    name        : type: String
#    conversion  : type: Number
#    isBase      : Schema.defaultBoolean()
#    allowDelete : Schema.defaultBoolean(true)
#    createdAt   :
#      type: Date
#      autoValue: ->
#        return new Date unless @isSet
#        return
#
#  productPrice: new SimpleSchema
#    branch:
#      type: String
#      optional: true
#    _id   : Schema.uniqueId
#    unit  : type: String
#    isBase: Schema.defaultBoolean()
#    sale  : Schema.defaultNumber()
#    import: Schema.defaultNumber()
#
#  productQuality: new SimpleSchema
#    branch: type: String
#    availableQuality   : Schema.defaultNumber()
#    inOderQuality      : Schema.defaultNumber()
#    inStockQuality     : Schema.defaultNumber()
#    saleQuality        : Schema.defaultNumber()
#    returnSaleQuality  : Schema.defaultNumber()
#    importQuality      : Schema.defaultNumber()
#    returnImportQuality: Schema.defaultNumber()

#  productVariantChoices: new SimpleSchema
#    name:
#      type: String
#
#    options:
#      type: [String]
#
#  productVariant: new SimpleSchema
#    option:
#      type: String
#
#    optionValue:
#      type: String
#
#  productExtract: new SimpleSchema
#    barcode: Schema.barcode
#
#    unit:
#      type: String
#
#    allowDelete:
#      type: Boolean
#      defaultValue: true
#
#    variants:
#      type: [@productVariant]
#      optional: true
#
#    price:
#      type: Number
#      defaultValue: 0