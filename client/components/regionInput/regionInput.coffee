Wings.defineHyper 'regionInput',
  helpers:
    activeClass: -> if Template.instance().hasFocus.get() then 'active' else ''
    prefixClass: -> if @prefix then 'prefix' else ''
  created: -> Template.instance().hasFocus = new ReactiveVar(false)
  rendered: ->
    if @data.value
      if @data.type is 'number'
        @ui.$source.val accounting.formatNumber(@data.value)
      else
        @ui.$source.val @data.value

  events:
    "focus input": -> Template.instance().hasFocus.set(true)
    "blur input": -> Template.instance().hasFocus.set(false)
    "input input": (event, template) ->
      template.ui.$source.val accounting.formatNumber(template.ui.$source.val()) if template.data.type is 'number'
