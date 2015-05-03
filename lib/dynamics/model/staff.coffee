Wings.Document.register 'staffs', class Staff
  name: ""

Document.Staff.attachSchema new SimpleSchema
  name:
    type: String
    unique: true

  image:
    type: String
    optional: true

  creator   : Wings.Schema.creator
  slug      : Wings.Schema.slugify('Staff')
  version   : { type: Wings.Schema.version }