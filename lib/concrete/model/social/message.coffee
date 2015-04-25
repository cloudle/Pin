class Model.Message
  @MessageTypes:
    direct  : 1
    channel : 2
    group   : 3

  constructor: (doc) -> @[key] = value for key, value of doc
#  @insert: (parent, message, messageType, separator = true) ->
#    newMessage = { creator: Meteor.userId(), parent: parent, message: message, messageType: messageType }
#    Wings.IRUS.insert(Schema.Message, newMessage, Wings.Validators.Social.messageInsert)

#----------------------------------------------------------------------------------------------------------------------
#Schema.Message.before.insert (userId, message) ->
#  console.log "this is isClient" if Meteor.isClient
#  console.log "this is isServer" if Meteor.isServer
#  if latestMessage = Schema.Message.findOne({parent: message.parent}, {sort: {createAt: -1}})
#    dateDiffInMinute = Math.round((((new Date() - latestMessage.createAt) % 86400000) % 3600000) / 60000)
#    message.separator = latestMessage.creator isnt userId or dateDiffInMinute > 6

