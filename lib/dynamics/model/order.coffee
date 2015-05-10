Wings.Document.register 'orders', 'Order', class Order
  @transform: (doc) ->

Document.Order.attachSchema new SimpleSchema
  branch:
    type: String
    optional: true

  seller:
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

  discountCash: Schema.defaultNumber()
  depositCash : Schema.defaultNumber()
  totalPrice  : Schema.defaultNumber()
  finalPrice  : Schema.defaultNumber()
  creator     : Schema.creator
  version     : { type: Schema.version }


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

