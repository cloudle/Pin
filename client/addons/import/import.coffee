Wings.defineHyper 'import',
  helpers:
    imports: -> Document.Import.find()
  events:
    "click .doc-item": -> Wings.go('import', @slug)
    "keyup input.insert": (event, template) ->
      if event.which is 13
        $name = $(template.find(".wings-field.insert"))
        Document.Import.insert { creator: Meteor.userId(), name: $name.val() }, (error, result) ->
          (console.log error; return) if error
          newImport = Document.Import.findOne(result)
          Wings.go 'import', newImport.slug
