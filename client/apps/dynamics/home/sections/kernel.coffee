Wings.defineWidget 'kernel',
  helpers:
    messageCreator: -> Meteor.users.findOne(@creator)

#  created: ->
#    timeStamp = new Date()
#    @incomingObserver = currentMessages.observeChanges
#      added: (id, instance) ->
#        createjs.Sound.play("incomeMessage") if instance.createAt > timeStamp
#        console.log 'ping..'
#  destroyed: ->
#    @incomingObserver.stop()

  events:
    "keyup .messenger-input": (event, template) ->
      if event.which is 13 and currentChannel = Session.get("currentChannel")
        $message = $(event.currentTarget)
#        result = Model.Message.insert(currentChannel._id, $message.val(), currentChannel.channelType)
        Meteor.call 'sendMessage', currentChannel._id, $message.val(), currentChannel.channelType, (err, result) ->
          if result.valid then $message.val('') else console.log result.error