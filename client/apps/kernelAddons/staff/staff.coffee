Wings.defineHyper 'staff',
  helpers:
    products: -> Document.Staff.find()
    zeroState: -> !Document.Staff.findOne()

  events:
    "click .doc-item": -> Wings.go('staff', @slug)
    "keyup input.insert": (event, template) ->
      if event.which is 13
        Document.Staff.insert { creator: Meteor.userId(), name: template.ui.$insertInput.val() }, (error, result) ->
          (console.log error; return) if error
          newStaff = Document.Staff.findOne(result)
          Wings.go 'staff', newStaff.slug