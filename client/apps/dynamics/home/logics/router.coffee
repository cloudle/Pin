findChannel = (params) -> Schema.Channel.findOne({slug: params.channel})

#Router.map ->
#  @route 'messages',
#    path: '/messages/:channel'
#    template: 'home'
#    data: ->
#      currentChannel = findChannel(@params)
##      Session.set("")
#      messages: Schema.Message.find({parent: currentChannel?._id}, {sort: {createAt: 1}})

#Wings.Router.add
#  name: 'messages'
#  path: '/messages/:channel'
#  template: 'home'
#
#  data: ->
#    currentChannel = findChannel(@params)
#    Session.set("")
#    messages: Schema.Message.find({parent: currentChannel?._id}, {sort: {createAt: 1}})
#
#Wings.Router.add
#  name  : 'home'
#  path  : '/'
#  action: -> @redirect