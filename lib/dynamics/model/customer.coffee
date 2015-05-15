Wings.Document.register 'customers', 'Customer', class Customer
  @transform: (doc) ->
    doc.update = (option, callback) ->
      return unless typeof option is "object"

      updateCustomer = {}
      if option.businessOwner and option.businessOwner isnt doc.businessOwner
        updateCustomer.$set = {businessOwner: option.businessOwner}
      else if option.businessOwner is ""
        updateCustomer.$unset = {businessOwner: ""}

      if option.companyPhone and option.companyPhone isnt doc.companyPhone
        updateCustomer.$set = {companyPhone: option.companyPhone}
      else if option.companyPhone is ""
        updateCustomer.$unset = {companyPhone: ""}

      if option.companyAddress and option.companyAddress isnt doc.companyAddress
        updateCustomer.$set = {companyAddress: option.companyAddress}
      else if option.companyAddress is ""
        updateCustomer.$unset = {companyAddress: ""}

      Document.Customer.update doc._id, updateCustomer, callback


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