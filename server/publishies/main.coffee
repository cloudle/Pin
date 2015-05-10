#Meteor.publish 'fake', ->
#  self = @
#  setTimeout ->
#    self.ready()
#  , 20000

Meteor.publish null, -> Storage.ProductImage.find({})
Meteor.publish null, -> Storage.UserImage.find({})

Meteor.publish "channels", -> Document.Channel.find({})
Meteor.publish "friends",  -> Meteor.users.find({})
Meteor.publish "messages", -> Document.Message.find({})

Meteor.publish "branches", -> Document.Branch.find({})
Meteor.publish "products", -> Document.Message.find({})
Meteor.publish "staffs", -> Document.Message.find({})

Meteor.publish "topDocuments", (collectionName) ->
  Document[collectionName].find({}, {limit: 20})

Meteor.publish "sluggedDocument", (collectionName, slug) ->
  Document[collectionName].find({slug: slug}, {limit: 1})

Meteor.publish "friendMessages", (friendId) ->
  Document.Message.find $or: [
    {parent: friendId, creator: @userId}
    {creator: @userId, parent: friendId }
  ]



