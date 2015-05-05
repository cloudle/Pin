Wings.Document.register 'products', 'Product', class Product
  @insert: (doc, callback) -> @document.insert doc, callback

Module "Schema",
  productUnit: new SimpleSchema
    _id: Schema.uniqueId

    name:
      type: String

    isBase:
      type: Boolean
      defaultValue: false

    conversion:
      type: Number

  productVariantChoices: new SimpleSchema
    name:
      type: String

    options:
      type: [String]

  productVariant: new SimpleSchema
    option:
      type: String

    optionValue:
      type: String

  productExtract: new SimpleSchema
    barcode: Schema.barcode

    unit:
      type: String

    allowDelete:
      type: Boolean
      defaultValue: true

    variants:
      type: [@productVariant]
      optional: true

    price:
      type: Number
      defaultValue: 0

Document.Product.attachSchema new SimpleSchema
  name:
    type: String
    index: 1
    unique: true

  image:
    type: String
    optional: true

  price:
    type: Number
    defaultValue: 0

  useAdvancePrice:
    type: Boolean
    defaultValue: false

  useVariant:
    type: Boolean
    defaultValue: false

  units:
    type: [Schema.productUnit]
    optional: true

  variantChoices:
    type: [Schema.productVariantChoices]
    optional: true

  extracts:
    type: [Schema.productExtract]
    optional: true

  creator   : Schema.creator
  slug      : Schema.slugify('Product')
  version   : { type: Schema.version }
