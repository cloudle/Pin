Wings.defineWidget 'order',
  helpers:
    products: -> Document.Order.find()
    zeroState: -> !Document.Order.findOne()

  events:
    "click .create-command": ->
      Document.Order.insert {
        creator    : Meteor.userId()
      }, (error, result) ->
        (console.log error; return) if error
        newOrder = Document.Order.findOne(result)
        Wings.go 'order', newOrder.slug

    "click .doc-item": -> Wings.go('order', @slug)
    "keyup input.insert": (event, template) ->
      if event.which is 13
        Document.Order.insert {
          creator    : Meteor.userId()
        }, (error, result) ->
          (console.log error; return) if error
          newOrder = Document.Order.findOne(result)
          Wings.go 'order', newOrder.slug