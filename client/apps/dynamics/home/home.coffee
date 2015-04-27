Wings.defineApp 'home',
  customers: -> Schema.Customer.find({})
  groupName: -> console.log @groupName; @groupName
#  rendered: -> Meteor.subscribe("customer")
