Meteor.startup ->
  moment.locale('vi')
  createjs.Sound.registerSound({src:"sounds/incoming.mp3", id: "incomeMessage"})