addons = ['news', 'product', 'customer', 'staff', 'order']
actions = ['detail', 'edit']
kernelAddonRegion = { to: "kernelAddon" }

Module "Wings.Router",
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