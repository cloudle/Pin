Wings.defineApp 'home',
  helpers:
    customers: -> Schema.Customer.find({})
    groupName: -> console.log @groupName; @groupName
    kernelCollapseClass: -> if Session.get("kernelAddonVisible") then 'collapse' else 'expand'

  rendered: -> console.log 'rendered...'
