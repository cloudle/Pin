Wings.Document.register 'customers', 'Customer', class Customer
  name: ""

Document.Customer.attachSchema new SimpleSchema
  name:
    type: String
    index: 1
    unique: true

  creator   : Schema.creator
  slug      : Schema.slugify('Customer')
  version   : { type: Schema.version }