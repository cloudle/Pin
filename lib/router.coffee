Router.configure
  layoutTemplate: 'ApplicationLayout'

currentDocInstance = {}

kernelAddonRegion = {to: "kernelAddon"}
Router.route '/:slug?/:sub?/:subslug?/:action?',
  name: 'home'
  template: 'home'
  waitOn: ->
    if Wings.Router.isValid(@)
      if @params.subslug
        Meteor.subscribe("sluggedDocument", @params.sub.toCapitalize(), @params.subslug)
      else
        Meteor.subscribe("topDocuments", @params.sub.toCapitalize())
  onBeforeAction: ->
    if @ready()
      Wings.Router.renderAddon(@)
      @next()

  data: ->
    channel = findChannel(@params)
    Session.set "currentChannel", channel.instance
    Session.set "kernelAddonVisible", !!@params.sub
    Session.set "currentAddon", @params.sub
    Session.set "currentAppColor", _(navigationMenus).findWhere({app: @params.sub})?.color

    predicate = if channel.isDirect then {} else {parent: channel.instance?._id}

    result =
      messages: Document.Message.find(predicate, {sort: {createAt: 1}})
      sub     : @params.sub
      subslug : @params.subslug

    if Wings.Router.isValid(@)
      if @params.subslug
        result.instance = Document[@params.sub.toCapitalize()].findOne({slug: @params.subslug})
      else
        result.documents = Document[@params.sub.toCapitalize()].find({})

    result

findChannel = (params) ->
  chanelResult = {}
  if params.slug?.substr(0, 1) is "@"
    chanelResult.instance = Meteor.users.findOne({'profile.slug': params.slug.substr(1)})
    chanelResult.isDirect = true
  else
    chanelResult.instance = Document.Channel.findOne({slug: params.slug})

  chanelResult

Module "Wings",
  go: (sub, subslug, action) ->
    return if !slug = Router.current().params.slug ? null
    Router.go 'home', {slug: slug, sub: sub, subslug: subslug, action: action}
