recalculationOrder = (orderId) ->
  importFound = Document.Order.findOne(orderId)
  totalPrice = 0
  (totalPrice += detail.quality * detail.price) for detail in importFound.details
  finalPrice = totalPrice - importFound.discountCash
  Document.Order.update importFound._id, $set:{totalPrice: totalPrice, finalPrice: finalPrice}

Wings.Document.register 'orders', 'Order', class Order
  @transform: (doc) ->
    doc.buyerInstance = -> Document.Customer.findOne(doc.buyer)

    doc.updateOrder = (option, callback) ->
      return unless typeof option is "object"

      updateOrder = {}
      if option.buyer and option.buyer isnt doc.buyer
        updateOrder.$set = {buyer: option.buyer}

      if option.description and option.description isnt doc.description
        updateOrder.$set = {description: option.description}

      if option.orderType and option.orderType isnt doc.orderType
        updateOrder.$set = {orderType: option.orderType}

      if option.discountCash and option.discountCash isnt doc.discountCash
        updateOrder.$set = {discountCash: option.discountCash}

      if option.depositCash and option.depositCash isnt doc.depositCash
        updateOrder.$set = {depositCash: option.depositCash}

      Document.Order.update doc._id, updateOrder, callback

    doc.addDetail = (productUnitId, quality, price, callback) ->
      return console.log('Order không tồn tại.') if (!self = Document.Order.findOne doc._id)

      product = Document.Product.findOne({'units._id': productUnitId})
      return console.log('Khong tim thay Product') if !product
      productUnit = _.findWhere(product.productUnits, {_id: productUnitId})
      return console.log('Khong tim thay ProductUnit') if !productUnit

      if product and quality > 0 and price >= 0
        detailFindQuery = {product: product._id, productUnit: productUnitId, price: price}
        detailFound = _.findWhere(self.details, detailFindQuery)
        console.log doc.details, detailFindQuery, detailFound

        console.log 'ok'
        if detailFound
          detailIndex = _.indexOf(self.details, detailFound)
          updateQuery = {$inc:{}}
          updateQuery.$inc['details.'+detailIndex+'.quality'] = quality
          recalculationOrder(self._id) if Document.Order.update(self._id, updateQuery, callback)

        else
          detailFindQuery.quality = quality
          recalculationOrder(self._id) if Document.Order.update(self._id, { $push: {details: detailFindQuery} }, callback)

    doc.editDetail = (detailId, quality, price) ->
      return console.log('Order không tồn tại.') if (!self = Document.Order.findOne doc._id)

      detailFound = _.findWhere(self.details, {_id: detailId})
      return console.log('Thong tin detail sai') if !detailFound
      return console.log('Thong tin sai') if !quality or quality < 0 or !price  or price < 0

      detailIndex = _.indexOf(self.details, detailFound)
      updateDetail = {$set:{}}
      updateDetail.$set['details.'+detailIndex+'.quality'] = quality
      updateDetail.$set['details.'+detailIndex+'.price'] = price
      recalculationOrder(self._id) if Document.Order.update(self._id, updateDetail, callback)

    doc.removeDetail = (detailId, callback) ->
      return console.log('Order không tồn tại.') if (!self = Document.Order.findOne doc._id)
      return console.log('OrderDetail không tồn tại.') if (!detailFound = _.findWhere(self.details, {_id: detailId}))
      detailIndex = _.indexOf(self.details, detailFound)
      removeDetailQuery = { $pull:{} }
      removeDetailQuery.$pull.details = self.details[detailIndex]
      recalculationOrder(self._id) if Document.Order.update(self._id, removeDetailQuery, callback)

    doc.submit = ->
      return console.log('Order không tồn tại.') if (!self = Document.Order.findOne doc._id)
      return console.log('Order đã Submit') if self.orderType isnt Enum.orderType.created

      for detail, detailIndex in self.details
        product = Document.Product.findOne({'units._id': detail.productUnit})
        return console.log('Khong tim thay Product') if !product
        productUnit = _.findWhere(product.units, {_id: detail.productUnit})
        return console.log('Khong tim thay ProductUnit') if !productUnit
      Meteor.call 'orderSubmit', self._id

    doc.addDelivery = (option, callback) ->
      return console.log('Order không tồn tại.') if (!self = Document.Order.findOne doc._id)
      return console.log('Customer không tồn tại.') if (!customer = Document.Customer.findOne(self.buyer))
      return console.log('Delivery tồn tại.') if self.deliveryStatus

      addDeliver = {$push: {}}
      addDeliver.description        = option.description if Math.check(option.deliveryDate, String)
      addDeliver.deliveryDate       = option.deliveryDate if Math.check(option.deliveryDate, Date)
      addDeliver.contactName        = option.name ? customer.name
      addDeliver.contactPhone       = option.phone ? customer.phone
      addDeliver.deliveryAddress    = option.address ? customer.address
      addDeliver.transportationFee  = 0
      addDeliver.createdAt          = new Date()

      Document.Order.update self._id, addDeliver, callback

    doc.deliveryReceipt = (staffId = Meteor.userId(), callback)->
      return console.log('Order không tồn tại.') if (!self = Document.Order.findOne doc._id)
      return console.log('Delivery tồn tại.') unless self.deliveryStatus
      return console.log('Delivery đang được giao.') if self.deliveryStatus isnt Enum.created
      return console.log('Staff không tồn tại.') if !@Meteor.users.findOne(staffId)

      deliveryLastIndex = self.deliveries.length - 1
      deliveryReceiptUpdate = {$set:{}}
      deliveryReceiptUpdate.$set['deliveries.'+deliveryLastIndex +'.shipper'] = staffId
      Document.Order.update self._id, deliveryReceiptUpdate, callback

    doc.deliverySucceed = (staffId = Meteor.userId(), callback)->
      deliveryLastIndex = self.deliveries.length - 1
      deliveryReceiptUpdate = {$unset:{}}
      deliveryReceiptUpdate.$unset['deliveries.'+deliveryLastIndex +'.shipper'] = ""
      Document.Order.update self._id, deliveryReceiptUpdate, callback

Module "Enum",
  orderType:
    created   : 0
    submitted : 1

  deliveryStatus:
    created  : 0
    delivered: 1
    succeed  : 2

Document.Order.attachSchema new SimpleSchema
  saleCode:
    type: String
    defaultValue: Random.id()
    index: 1
    unique: true

  branch:
    type: String
    optional: true

  buyer:
    type: String
    optional: true

  orderName:
    type: String
    defaultValue: 'NEW TAB'

  description:
    type: String
    optional: true

  orderType:
    type: Number
    defaultValue: Enum.orderType.created

  creator   : Schema.creator
  slug      : Schema.slugify('Order', 'saleCode')
  version   : { type: Schema.version }

  returns     : type: [String],  optional: true
  discountCash: type: Number , defaultValue: 0
  depositCash : type: Number , defaultValue: 0
  totalPrice  : type: Number , defaultValue: 0
  finalPrice  : type: Number , defaultValue: 0
  allowDelete : type: Boolean, defaultValue: true
  creator     : Schema.creator
  version     : type: Schema.version


  details: type: [Object], defaultValue: []
  'details.$._id'          : Schema.uniqueId
  'details.$.product'      : type: String
  'details.$.productUnit'  : type: String
  'details.$.quality'      : type: Number
  'details.$.price'        : type: Number
  'details.$.returnQuality': Schema.defaultNumber()


  deliveryStatus                  : type: Number  , optional: true
  deliveries                      : type: [Object], defaultValue: []
  'deliveries.$.shipper'          : type: String  , optional: true
  'deliveries.$.buyer'            : type: String  , optional: true
  'deliveries.$.deliveryCode'     : type: String  , optional: true
  'deliveries.$.contactName'      : type: String  , optional: true
  'deliveries.$.description'      : type: String  , optional: true
  'deliveries.$.contactPhone'     : type: String  , optional: true
  'deliveries.$.deliveryAddress'  : type: String  , optional: true
  'deliveries.$.deliveryDate'     : type: String  , optional: true
  'deliveries.$.transportationFee': type: Number  , optional: true
  'deliveries.$.createdAt'        : type: Date    , optional: true

