Wings.Document.register 'messages', 'Message', class Message
  @MessageTypes:
    direct  : 1
    channel : 2
    group   : 3

  constructor: (doc) -> @[key] = value for key, value of doc