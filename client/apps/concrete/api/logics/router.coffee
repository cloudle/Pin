scope = logics.api = {}

Wings.Router.add
  template: 'api'
  onBeforeAction: ->
    if @ready()
      Wings.Router.setup(scope, setups.apiInits, "apiDocumentation")
      @next()
  data: ->
    Wings.Router.setup(scope, setups.apiReactives)
    return {
      apiNodes: Schema.ApiNode.find({parent: {$exists: false}}, {sort: {name: 1}})
      apiTechLeaves: Schema.ApiMachineLeaf.find({})
      apiBizLeaves: Schema.ApiHumanLeaf.find({})
    }