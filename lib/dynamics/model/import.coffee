Wings.Document.register 'imports', 'Import', class Import
  @transform: (doc) ->


Document.Import.attachSchema new SimpleSchema
  branch:
    type: String
    optional: true

  provider:
    type: String
    optional: true

  importCode:
    type: String
    optional: true

  description:
    type: String
    optional: true

  importType:
    type: Number
    defaultValue: 0

  sales:
    type: [String]
    optional: true

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
  'details.$._id'                : Schema.uniqueId
  'details.$.product'            : type: String
  'details.$.productUnit'        : type: String
  'details.$.expire'             : type: Date
  'details.$.quality'            : Schema.defaultNumber(1)
  'details.$.price'              : Schema.defaultNumber()
  'details.$.availableQuality'   : Schema.defaultNumber()
  'details.$.inOderQuality'      : Schema.defaultNumber()
  'details.$.inStockQuality'     : Schema.defaultNumber()
  'details.$.saleQuality'        : Schema.defaultNumber()
  'details.$.returnSaleQuality'  : Schema.defaultNumber()
  'details.$.importQuality'      : Schema.defaultNumber()
  'details.$.returnImportQuality': Schema.defaultNumber()