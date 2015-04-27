Wings.defineWidget 'channel',
  helpers:
    isActiveChannel: -> if Session.get('currentChannel')?._id is @_id then 'active' else ''
    channels: -> Schema.Channel.find({channelType: Model.Channel.ChannelTypes.public})
    groups: -> Schema.Channel.find({channelType: Model.Channel.ChannelTypes.private})

  rendered: ->
    Meteor.setTimeout ->
      Session.set('currentChannel', Schema.Channel.findOne())
    , 1000

  events:
    "click .channel-item": -> Session.set 'currentChannel', @