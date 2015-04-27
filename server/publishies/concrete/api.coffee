recursiveRemoveChild = (childNodes)->
  Schema.ApiNode.find({_id: {$in:childNodes}}).forEach (apiNode) ->
    Schema.ApiNode.remove apiNode._id
    Schema.ApiHumanLeaf.remove({parent: apiNode._id})
    Schema.ApiMachineLeaf.remove({parent: apiNode._id})

    recursiveRemoveChild(apiNode.childNodes) if apiNode.childNodes

Schema.ApiNode.after.remove (userId, doc) ->
  Schema.ApiNode.update(doc.parent, {$pull: {childNodes: doc._id}}) if doc.parent
  Schema.ApiHumanLeaf.remove({parent: doc._id})
  Schema.ApiMachineLeaf.remove({parent: doc._id})
  recursiveRemoveChild(doc.childNodes) if doc.childNodes

Schema.ApiNode.allow
  insert: (userId, apiNode) -> Model.Api.isValidNode(apiNode).valid
  update: (userId, apiNode, fieldNames, modifier)->
    if _.contains(fieldNames, "childNodes")
      if Schema.ApiNode.findOne(modifier.$push.childNodes) then return true else return false
    return true
  remove: (userId, apiNode)-> true