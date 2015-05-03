Wings.defineWidget 'customer',
  helpers:
    products: -> Document.Customer.find()
    zeroState: -> !Document.Customer.findOne()

Wings.defineHyper 'customerEmpty',
  events:
    "click .insert-command": (event, template) ->
    "keyup input.insert": (event, template) ->
      if event.which is 13
        Document.Customer.insert { creator: Meteor.userId(), name: template.ui.$insertInput.val() }, (error, result) ->
          (console.log error; return) if error
          newCustomer = Document.Customer.findOne(result)
          Wings.go 'customer', newCustomer.slug