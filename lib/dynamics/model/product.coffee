Wings.Document.register 'products', class Product
  @insert: (doc, callback) -> @document.insert doc, callback

Document.Product.attachSchema new SimpleSchema
  name:
    type: String
    unique: true

  price:
    type: Number
    defaultValue: 0

  importPrice:
    type: Number
    defaultValue: 0

  image:
    type: String
    optional: true

  creator   : Wings.Schema.creator
  slug      : Wings.Schema.slugify('Product')
  version   : { type: Wings.Schema.version }