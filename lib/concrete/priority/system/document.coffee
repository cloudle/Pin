Module "Wings.Document",
  register: (documentName, defination = {}) ->
    Document[defination.name] = document = new Meteor.Collection documentName,
      transform: (doc) ->
        doc.Document = defination.name
        defination.transform?(doc)
        doc

    Model[defination.name]  = model  = defination
    model.document = document

Module 'Document',
  ApiNode         : new Meteor.Collection 'apiNodes'
  ApiMachineLeaf  : new Meteor.Collection 'apiMachineLeaves'
  ApiHumanLeaf    : new Meteor.Collection 'apiHumanLeaves'

#  Channel         : new Meteor.Collection 'channels'
#  Message         : new Meteor.Collection 'messages'
