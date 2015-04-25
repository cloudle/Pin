Wings.defineHyper 'wingsEditor',
  helpers:
    fieldValue: -> @model?[@field]
    saveRemainingClass: -> if Template.instance().saveRemaining.get() then 'save-remaining' else ''
    activeClass: -> if Template.instance().hasFocus.get() then 'active' else ''

  created: ->
    Template.instance().saveRemaining = new ReactiveVar(false)
    Template.instance().hasFocus = new ReactiveVar(false)

  events:
    "click .button.save": (event, template) ->
      newValue = $(template.find(".wings-editor")).html()
      updateResult = Wings.IRUS.setField(@collection, @model, @field, newValue)
      updateResult.error unless updateResult.valid
      Template.instance().saveRemaining.set(!updateResult.valid)

    "input .wings-editor": -> Template.instance().saveRemaining.set(true)
    "focus .wings-editor": -> Template.instance().hasFocus.set(true)
    "blur .wings-editor": -> Template.instance().hasFocus.set(false)