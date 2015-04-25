setups.apiInits = []
setups.apiReactives = []

#setups.apiInits.push (scope) ->

setups.apiReactives.push ->
  Session.set "currentApiNode", Schema.ApiNode.findOne Session.get("currentApiNode")?._id ? {}