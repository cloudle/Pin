Document.Branch.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.Product.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> true #userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.Import.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> true #userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.Customer.allow
  insert: (userId, doc) -> true #userId is doc.creator
  update: (userId, doc, fields, modifier) -> userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.Order.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.Staff.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.News.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.PriceBook.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Document.System.allow
  insert: (userId, doc) -> userId is doc.creator
  update: (userId, doc, fields, modifier) -> userId is doc.creator
  remove: (userId, doc) -> userId is doc.creator

Storage.ProductImage.allow
  insert: (userId, doc) -> true
  update: (userId, doc, fieldNames, modifier) -> true
  remove: (userId, doc) -> true
  download: (userId)-> true

Storage.UserImage.allow
  insert: (userId, doc) -> true
  update: (userId, doc, fieldNames, modifier) -> true
  remove: (userId, doc) -> true
  download: (userId)-> true