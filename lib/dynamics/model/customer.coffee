Wings.Document.register 'customers', 'Customer', class Customer
  name: ""

Document.Customer.attachSchema new SimpleSchema
  name:
    type: String

  creator   : Wings.Schema.creator
  slug      : Wings.Schema.slugify('Customer')
  version   : { type: Wings.Schema.version }