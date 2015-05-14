Wings.defineWidget 'customer',
  helpers:
    customers: -> Document.Customer.find()

  events:
    "click .doc-item": -> Wings.go('customer', @slug)
    "keyup input.insert": (event, template) ->
      if event.which is 13
        Document.Customer.insert {
          creator    : Meteor.userId(),
          companyName: template.ui.$insertInput.val()
        }, (error, result) ->
          (console.log error; return) if error
          newCustomer = Document.Customer.findOne(result)
          Wings.go 'customer', newCustomer.slug

Wings.defineHyper 'customerEmpty',
  events:
    "click .insert-command": (event, template) ->