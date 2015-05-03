Meteor.methods
  sendMessage: (parent, message, messageType) ->
    newMessage = { creator: @userId, parent: parent, message: message, messageType: messageType, separator: true }

    if latestMessage = Document.Message.findOne({parent: parent}, {sort: {createAt: -1}})
      dateDiffInMinute = Math.round((((new Date() - latestMessage.createAt) % 86400000) % 3600000) / 60000)
      newMessage.separator = latestMessage.creator isnt @userId or dateDiffInMinute > 6

    Wings.IRUS.insert(Document.Message, newMessage, {})