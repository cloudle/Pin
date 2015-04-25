routerBase =
  layoutTemplate: 'defaultLayout'
  loadingTemplate: 'silentLoadingLayout'
  onAfterAction: ->
    Wings.Helper.animateUsing("#container", 'fadeInDown')

Module 'Wings.Router',
  routes: []
  setupHistories: []
  Base: routerBase

  setup: (scope, initializers, appName) ->
    return if !initializers or !Array.isArray(initializers) or _.contains(@setupHistories, appName)
    init(scope) for init in initializers when typeof(init) is 'function'
    @setupHistories.push appName if appName

  add: (routes, baseRoute = @Base) ->
    routes = [routes] unless Array.isArray(routes)
    for route in routes
      routeLayoutTemplate = route.layoutTemplate
      _.extend(route, baseRoute)
      route.layoutTemplate = routeLayoutTemplate if routeLayoutTemplate

      if route.waitOnDependency
        route.waitOn = ->
          results = Wings.Dependency.resolve(route.waitOnDependency)
          item.ready() for item in results
          results

      Wings.Router.routes.push route
    return

  buildRoutes: ->
    for route in @routes
      template = undefined

      if route.template and route.path
        template = route.template; delete route.template
      else if route.template
        template = route.template; delete route.template
        route.path = "/#{template}"
      else if route.path
        template = route.path.substring(1)

      Router.route template, route if template