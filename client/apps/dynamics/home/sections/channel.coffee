Wings.defineWidget 'channel',
  helpers:
    isActiveChannel: -> if Session.get('currentChannel')?._id is @_id then 'active' else ''
    channels: -> Schema.Channel.find({channelType: Model.Channel.ChannelTypes.public})
    groups: -> Schema.Channel.find({channelType: Model.Channel.ChannelTypes.private})
    friends: -> Meteor.users.find()

  events:
    "click .channel-item": ->
      if @profile
        Router.go "/messages/@#{@profile.slug}"
      else
        Router.go 'messages', {slug: @slug}