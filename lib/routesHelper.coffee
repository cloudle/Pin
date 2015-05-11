addons = ['news', 'product', 'customer', 'user', 'order']
actions = ['detail', 'edit']
kernelAddonRegion = { to: "kernelAddon" }

Module "Wings.Router",
  findChannel: (slug) ->
    chanelResult = {}
    if slug?.substr(0, 1) is "@"
      chanelResult.instance = Meteor.users.findOne({'slug': slug.substr(1)})
      chanelResult.isDirect = true
    else
      chanelResult.instance = Document.Channel.findOne({slug: slug})
    chanelResult

  isValid: (scope) -> return _(addons).contains(scope.params.sub)
  renderAddonNotFound: (scope) -> scope.render 'addonNotFound', kernelAddonRegion
  renderAddonDocumentNotFound: (scope) -> scope.render 'addonDocumentNotFound', kernelAddonRegion
  renderAddonDefault: (scope) -> scope.render scope.params.sub, kernelAddonRegion

  renderAddon: (scope) ->
    if @isValid(scope)
      if documentWantedAndExist(scope)
        @renderAddonDetail(scope)
      else if documentWanted(scope)
        @renderAddonDocumentNotFound(scope)
      else
        @renderAddonDefault(scope)
    else
      @renderAddonNotFound(scope)

  #this mean the document is exist! check for action
  renderAddonDetail: (scope) ->
    if scope.params.action
      childTemplate = "#{scope.params.sub}#{scope.params.action.toCapitalize()}"
      if Template[childTemplate]
        scope.render childTemplate, kernelAddonRegion
      else
        @renderAddonNotFound(scope)
    else
      scope.render "#{scope.params.sub}Detail", kernelAddonRegion

documentWantedAndExist = (scope) -> scope.params.subslug and Document[scope.params.sub.toCapitalize()]?.findOne({slug: scope.params.subslug})
documentWanted = (scope) -> !!scope.params.subslug