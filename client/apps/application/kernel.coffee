messengerScrollTopHandler = ->
  console.log 'scroll top'

Wings.defineWidget 'kernel',
  created: ->
    Meteor.subscribe("messages")
    timeStamp = new Date()
    @incomingObserver = Document.Message.find().observeChanges
      added: (id, instance) ->
        if instance.version?.createdAt > timeStamp
          Sounds.incoming.start()
          console.log 'ping..'

#    @incomingObserver = currentMessages.observeChanges
#      added: (id, instance) ->
#        createjs.Sound.play("incomeMessage") if instance.createAt > timeStamp
#        console.log 'ping..'

  destroyed: ->
    @incomingObserver.stop()

  rendered: ->
    messenger = window.$kernelMessenger = $(@find(".messenger-scroller"))
    messenger.debounce "scrolltop", messengerScrollTopHandler, 100

  events:
    "keyup .messenger-input": (event, template) ->
      if event.which is 13 and currentChannel = Session.get("currentChannel")
        $message = $(event.currentTarget)
#        result = Model.Message.insert(currentChannel._id, $message.val(), currentChannel.channelType)
        Meteor.call 'sendMessage', currentChannel._id, $message.val(), currentChannel.channelType, (error, result) ->
          if error
            console.log error
          else
            $message.val(''); Sounds.incoming.start()
            window.$kernelMessenger.nanoScroller({ scroll: 'bottom' })

    "update .messenger-scroller": (event, template, vals) ->
      window.manualScrollMessenger = vals.maximum - vals.position > 40
      console.log window.manualScrollMessenger