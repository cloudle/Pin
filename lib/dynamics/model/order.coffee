Wings.Document.register 'orders', 'Order', class Order
  @transform: (doc) ->
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

      Document.Import.update doc._id, updateOrder, callback
    doc.addDetail = () ->
    doc.editDetail = () ->
    doc.removeDetail = () ->



Document.Order.attachSchema new SimpleSchema
  branch:
    type: String
    optional: true

  buyer:
    type: String
    optional: true

  saleCode:
    type: String
    optional: true

  description:
    type: String
    optional: true

  orderType:
    type: Number
    defaultValue: 0

  returns:
    type: [String]
    optional: true

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
  'details.$.returnQuality': type: Number


  deliveries                    : type: [Object], defaultValue: []
  'deliveries.$.shipper'        : type: String, optional: true
  'deliveries.$.buyer'          : type: String, optional: true
  'deliveries.$.deliveryCode'   : type: String, optional: true
  'deliveries.$.contactName'    : type: String, optional: true
  'deliveries.$.description'    : type: String, optional: true
  'deliveries.$.contactPhone'   : type: String, optional: true
  'deliveries.$.deliveryAddress': type: String, optional: true
  'deliveries.$.deliveryDate'   : type: String, optional: true
  'deliveries.$.createdAt'      : type: Date  , optional: true

