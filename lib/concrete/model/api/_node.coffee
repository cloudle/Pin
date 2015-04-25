Wings.Api = {}

Wings.Enum.nodeTypes =
  property: 1
  method  : 2
  example : 3

Wings.Api.isValidNode = (nodeObj) ->
  if Match.test(nodeObj.name, String) and nodeObj.name.length < 1
    return { valid: false, message: "invalid node name!" }

#  if Meteor.isServer
#    return { valid: false } if Schema.ApiNode.findOne({name: nodeObj.name})

  return { valid: true }

Wings.Api.insertNode = (name, parentId) ->
  newChild = {name: name}
  newChild.parent = parentId if parentId

  validation = Wings.Api.isValidNode(newChild)
  if !validation.valid
    console.log validation.message
    return

  childId = Schema.ApiNode.insert(newChild)
  Schema.ApiNode.update(parentId, {$push: {childNodes: childId}}) if parentId

Wings.Api.removeNode = (nodeId) -> Schema.ApiNode.remove(nodeId)