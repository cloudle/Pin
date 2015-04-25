resizeAction = ->
  Wings.Component.arrangeLayout()
  $(".nano").nanoScroller()

Wings.defineWidget "defaultLayout",
  rendered: ->
    $(window).resize -> resizeAction()

  destroyed: ->
    $(window).off("resize")