Wings.Document.register 'products', 'Product', class Product
  @insert: (doc, callback) -> @document.insert doc, callback
  @transform: (doc) ->
    return unless typeof doc.units is "object" or typeof doc.prices is "object"

    if doc.units.length is 0
      doc.insertBaseUnit = (option, callback) ->
        return unless typeof option is "object"
        if option.name
          unit  = {_id: Random.id(), name: option.name, conversion: 1, isBase: true}

          price = { unit: unit._id, isBase: true}
          price.sale   = option.salePrice if option.salePrice > 0
          price.import = option.importPrice if option.importPrice > 0

          Document.Product.update doc._id, {$push: {units: unit, prices: price}}, callback
    else
      doc.useAdvancePrice = true
      for unit, index in doc.units
        listPrices = _.where(doc.prices, {unit: unit._id})
        branchPrice = _.findWhere(listPrices, {unit: unit._id})
#        basePrice   = _.findWhere(listPrices, {unit: unit._id})

        doc.units[index].unitIndex = index
        if branchPrice
          doc.units[index].priceId     = branchPrice._id
          doc.units[index].priceIndex  = _.indexOf(doc.prices, branchPrice)
          doc.units[index].salePrice   = branchPrice.sale
          doc.units[index].importPrice = branchPrice.import
        else if basePrice
          doc.units[index].priceId     = basePrice._id
          doc.units[index].priceIndex  = _.indexOf(doc.prices, basePrice)
          doc.units[index].salePrice   = basePrice.sale
          doc.units[index].importPrice = basePrice.import

        if unit.isBase
          doc.unitIndex    = index
          doc.priceIndex   = index
          doc.baseUnit     = unit._id
          doc.baseUnitName = unit.name
          doc.barcode      = unit.barcode
          doc.salePrice    = doc.units[index].salePrice
          doc.importPrice  = doc.units[index].importPrice
          if branchPrice then doc.priceIndex = _.indexOf(doc.prices, branchPrice)
          else if basePrice then doc.priceIndex = _.indexOf(doc.prices, basePrice)

      doc.updateBaseUnit = (option, callback) ->
        return unless typeof option is "object"
        updateBaseUnitQuery = {$set:{}}

        if option.name and !_.contains(_.pluck(doc.units, 'name'), option.name)
          updateBaseUnitQuery.$set["units."+doc.unitIndex+".name"] = option.name
          Document.Product.update doc._id, updateBaseUnitQuery, callback

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

          Document.Product.update doc._id, {$push: {units: unit, prices: price}}, callback

      doc.updateUnit = (option, callback) ->
        return unless typeof option is "object"
        return unless unitFound = _.findWhere(doc.units, {_id: option.id})

        updateBaseUnitQuery = {$set:{}}
        listNames = _.pluck(doc.units, 'name')
        listNames = _.without(listNames, unitFound.name)

        if option.name and !_.contains(listNames, option.name)
          updateBaseUnitQuery.$set["units."+unitFound.unitIndex+".name"] = option.name
          Document.Product.update doc._id, updateBaseUnitQuery, callback

        if (option.salePrice and option.salePrice >= 0) or (option.importPrice and option.importPrice >= 0)
          updateBaseUnitQuery.$set["prices."+unitFound.priceIndex+".sale"]   = option.salePrice
          updateBaseUnitQuery.$set["prices."+unitFound.priceIndex+".import"] = option.importPrice

        Document.Product.update(doc._id, updateBaseUnitQuery, callback) unless _.isEmpty(updateBaseUnitQuery.$set)


Module "Schema",
  productUnit: new SimpleSchema
    _id       : Schema.uniqueId
    barcode   : Schema.barcode
    name      : type: String
    conversion: type: Number
    isBase    : Schema.booleanDefaultFalse

  productPrice: new SimpleSchema
#    branch:
#      type: String
#      optional: true
    _id   : Schema.uniqueId
    unit  : type: String
    isBase: Schema.booleanDefaultFalse
    sale  : Schema.numberDefaultZero
    import: Schema.numberDefaultZero

  productQuality: new SimpleSchema
    branch: type: String
    availableQuality   : Schema.numberDefaultZero
    inOderQuality      : Schema.numberDefaultZero
    inStockQuality     : Schema.numberDefaultZero
    saleQuality        : Schema.numberDefaultZero
    returnSaleQuality  : Schema.numberDefaultZero
    importQuality      : Schema.numberDefaultZero
    returnImportQuality: Schema.numberDefaultZero

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

  useAdvancePrice:
    type: Boolean
    defaultValue: false
#
#  baseUnit:
#    type: String
#    optional: true
#
#  barcode: Schema.barcode
#
#  price:
#    type: Number
#    defaultValue: 0
#
#  importPrice:
#    type: Number
#    defaultValue: 0

  units:
    type: [Schema.productUnit]
    defaultValue: []

  prices:
    type: [Schema.productPrice]
    defaultValue: []

  qualities:
    type: [Schema.productQuality]
    defaultValue: []

  creator   : Schema.creator
  slug      : Schema.slugify('Product')
  version   : { type: Schema.version }
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