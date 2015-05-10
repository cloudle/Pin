Wings.defineWidget 'order',
  helpers:
    products: -> Document.Order.find()
    zeroState: -> !Document.Order.findOne()