Router.configure
  layoutTemplate: 'ApplicationLayout'

Router.route '/', -> @redirect('/messages/')

Router.route '/messages/:slug?/:side?',
  name: 'messages'
  template: 'home'
  data: ->
    channel = findChannel(@params)
    Session.set "currentChannel", channel.instance
#    Session.set "kernelAddonVisible", !!@params.side
    Session.set "kernelAddonVisible", channel.isDirect

    predicate = if channel.isDirect then {} else {parent: channel.instance?._id}
    messages: Schema.Message.find(predicate, {sort: {createAt: 1}})

findChannel = (params) ->
  chanelResult = {}
  if params.slug?.substr(0, 1) is "@"
    chanelResult.instance = Meteor.users.findOne({'profile.slug': params.slug.substr(1)})
    chanelResult.isDirect = true
  else
    chanelResult.instance = Schema.Channel.findOne({slug: params.slug})

  chanelResult