Wings.Document.register 'priceBooks', class PriceBook
  name: ""

Document.PriceBook.attachSchema new SimpleSchema
  name:
    type: String
    unique: true

  creator   : Wings.Schema.creator
  slug      : Wings.Schema.slugify('PriceBook')
  version   : { type: Wings.Schema.version }