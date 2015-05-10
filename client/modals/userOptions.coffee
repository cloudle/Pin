optionMenus = [
  display: "Notifications"
  template: "notificationOptions"
,
  display: "Trình bày"
  template: "displayOptions"
,
  display: "Liên kết"
  template: "linkOptions"
,
  display: "Nâng cao"
  template: "advanceOptions"
]

Wings.defineModal "modalUserOptions",
  helpers:
    optionMenus: optionMenus
    detailTemplate: -> Session.get("userOptionActiveMenu")
    activeMenuClass: -> if @template is Session.get("userOptionActiveMenu") then 'active' else ''

  rendered: ->
    Session.set("userOptionActiveMenu", "notificationOptions")

  events:
    "click .option-menu": (event, template) -> Session.set("userOptionActiveMenu", @template)