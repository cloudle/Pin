Wings.defineWidget "ApplicationLayout",
  rendered: ->
    Session.set("applicationStatus", "Trạng thái ổn định.")
    $(window).resize -> resizeAction()

  destroyed: ->
    $(window).off("resize")

  events:
    "mouseover [wings-tip]": (event, tempate) ->
      Wings.Tip.handleMouseOver($(event.currentTarget))
    "mouseout [wings-tip]": (event, tempate) -> Wings.Tip.handleMouseOut()

resizeAction = ->
  Wings.Component.arrangeLayout()
  $(".nano").nanoScroller()