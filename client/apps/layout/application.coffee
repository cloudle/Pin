resizeAction = ->
  Wings.Component.arrangeLayout()
  $(".nano").nanoScroller()

Wings.defineWidget "ApplicationLayout",
  rendered: ->
    $(window).resize -> resizeAction()

  destroyed: ->
    $(window).off("resize")