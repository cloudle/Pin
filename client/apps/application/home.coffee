Wings.defineApp 'home',
  helpers:
    customers: -> Document.Customer.find({})
    groupName: -> console.log @groupName; @groupName

  rendered: ->
