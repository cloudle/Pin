Wings.defineWidget 'channel',
  helpers:
    isActiveChannel: -> if Session.get('currentChannel')?._id is @_id then 'active' else ''
    channels: -> Document.Channel.find({channelType: Model.Channel.ChannelTypes.public})
    groups: -> Document.Channel.find({channelType: Model.Channel.ChannelTypes.private})
    friends: -> Meteor.users.find()

  created: ->
    Meteor.subscribe("friends")
    Meteor.subscribe("channels")

  events:
    "click .channel-item": (event, template) ->
      data = template.data

      if @profile
        homePath = Router.routes['home'].path()
        homePath += "@#{@profile.slug}"
        homePath += "/#{data.sub}" if data.sub
        homePath += "/#{data.subslug}" if data.sub and data.subslug

        Router.go homePath
      else
        Router.go 'home', {slug: @slug, sub:data.sub, subslug:data.subslug}