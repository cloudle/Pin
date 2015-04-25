Wings.Api.Leaf =
  insertParamType: (source, type) ->
    if !source.type then source.type = [type] else source.type.push type unless _(source.type).findWhere({name: type.name}) > 0

  removeParamType: (source, type) ->
    return if !Array.isArray(source.type)
    @type.splice(source.type.indexOf(_(source.type).findWhere({name: name})), 1)

  insertParams: (leafId, params) ->
    params = @splitTypes(params) if typeof params is 'string'
    _(params).map (obj) -> obj.type = [obj.type]
    Schema.ApiMachineLeaf.update(leafId, {$push: {params: {$each: params}}}) if Array.isArray(params)
  removeParam: (leafId, name) -> Schema.ApiMachineLeaf.update(leafId, {$pull: {params: {name: name}}})

  insertMembers: (leafId, methods) ->
    members = @splitTypes(methods) if typeof methods is 'string'
    _(members).map (obj) -> obj.parent = leafId; obj.leafType = Wings.Enum.nodeTypes.property
    Wings.IRUS.insert(Schema.ApiMachineLeaf, member, Wings.Validators.leafCreate) for member in members

  remove: (leafId) -> Schema.ApiMachineLeaf.remove(leafId)

  splitTypes: (sourceString) ->
    results = []
    sources = sourceString.split(',')
    for source in sources
      separatorIndex = source.indexOf(":")
      if separatorIndex > 0
        result =
          name: source.substr(0, separatorIndex)
          type: {name: source.substr(separatorIndex+1)}
      else
        result = {name: source}

      results.push result

    results

#Wings.Api.isValidMachineLeaf = (leafOjb) ->
#  if Match.test(leafOjb.name, String) and leafOjb.name.length < 1
#    return { valid: false, message: "invalid leaf name!" }
#  if Match.test(leafOjb.parentId, String) and leafOjb.parentId.length < 1
#    return { valid: false, message: "invalid leaf parent!" }
#  return { valid: true }
#
#Wings.Api.insertMachineLeaf = (name, nodeType, returnType, parentId) ->
#  newLeaf = {name: name}
#  newLeaf.nodeType = nodeType if nodeType
#  newLeaf.returnType = returnType if returnType
#  newLeaf.parentId = parentId if parentId
#
#  validation = Wings.Api.isValidMachineLeaf(newLeaf)
#  (console.log validation.message; return ) if !validation.valid
#
#  Schema.ApiMachineLeaf.insert(newLeaf)
#
#Wings.Api.insertLeafParam = (param) ->
