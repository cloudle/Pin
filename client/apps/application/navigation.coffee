@navigationMenus = [
  description: 'Tin tức tự động'
  color: 'lime'
  icon: 'icon-world'
  app: "news"
,
#  description: 'Notification'
#  color: 'blue'
#  icon: 'icon-comment'
#  app: "notification"
#,
  description: 'Nội bộ'
  color: 'purple'
  icon: 'icon-battery'
  app: "staff"
,
  description: 'Sản phẩm'
  color: 'carrot'
  icon: 'icon-ticket'
  app: "product"
,
  description: 'Lịch làm việc'
  color: 'nephritis'
  icon: 'icon-date'
  app: "calendar"
,
  description: 'Khách hàng'
  color: 'magenta'
  icon: 'icon-id'
  app: "customer"
,
  description: 'Đơn hàng'
  color: 'sun-flower'
  icon: 'icon-mail-open-file'
  app: "order"
,
  description: 'Tùy chỉnh hệ thống'
  color: 'orange'
  icon: 'icon-tools'
  app: "system"
]

Template.navigation.helpers
  currentDescription: -> Session.get("currentAppDescription")
  currentColor: -> Session.get("temporaryAppColor") ? Session.get("currentAppColor")
  addonMenus: -> navigationMenus
  activeClass: -> if Session.get("currentAddon") is @app then 'active' else ''
  connectionStatus: -> Meteor.status().status

Template.navigation.events
  "click .addon-launcher": (event, template) -> Wings.go @app
  "click .app-descriptions": -> Session.set "kernelAddonVisible", !Session.get("kernelAddonVisible")
  "click .navigator.home": (event, template) -> Wings.go(Router.current().params.sub)
  "click .navigator.backward": (event, template) -> history.back()
  "click .navigator.forward": (event, template) -> history.forward()
  "mouseenter .addon-launcher": (event, template) ->
    Session.set "currentAppDescription", $(event.currentTarget).attr('description')
    Session.set "temporaryAppColor", @color
  "mouseleave .addon-launcher": (event, template) ->
    Session.set "currentAppDescription"
    Session.set "temporaryAppColor"
  "mouseenter .navigator": (event, template) -> Session.set "currentAppDescription", $(event.currentTarget).attr('description')
  "mouseleave .navigator": (event, template) -> Session.set "currentAppDescription"