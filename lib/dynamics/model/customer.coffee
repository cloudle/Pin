Wings.Document.register 'customers', 'Customer', class Customer
  @transform: (doc) ->

Document.Customer.attachSchema new SimpleSchema
  companyName:
    type: String
    index: 1
    unique: true

  businessOwner:
    type: String
    optional: true

  companyAddress:
    type: String
    optional: true

  companyPhone:
    type: String
    optional: true

  description:
    type: String
    optional: true

  image:
    type: String
    optional: true

  plans              : type: [Object], defaultValue: []
  'plans.$._id'      : type: String
  'plans.$.sale'     : type: String
  'plans.$.seller'   : type: String
  'plans.$.createdAt': type: String

  events              : type: [Object], defaultValue: []
  'events.$.owner'    : type: String
  'events.$.content'  : type: String
  'events.$.createdAt': type: Date


  creator   : Schema.creator
  slug      : Schema.slugify('Customer', 'companyName')
  version   : { type: Schema.version }