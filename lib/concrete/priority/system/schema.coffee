randomBarcode = (prefix="0", length=10)->
  prefix += Math.floor(Math.random() * 10) for i in [0...length]
  prefix

Module "Schema",
#  Essential: new SimpleSchema
#    creator: { type: Schema.creator }
#    version: { type: Schema.version }

  creator:
    type: String
    autoValue: -> Meteor.userId() if @isInsert and not @isSet

  uniqueId:
    type: String
    autoValue: ->
      Meteor.uuid() unless @isSet
      return

  barcode:
    type: String
    autoValue: ->
      randomBarcode() unless @isSet
      return

  version: new SimpleSchema
    createdAt:
      type: Date
      autoValue: ->
        if @isInsert
          return new Date
        else if @isUpsert
          return { $setOnInsert: new Date }
        return

    updateAt:
      type: Date
      autoValue: ->
        return new Date() if @isUpdate
        return

      denyInsert: true
      optional: true

  slugify: (source, field = 'name') ->
    type: String
    autoValue: ->
      return if !@isInsert or !slugifySource = @field(field)?.value
      slugify = Wings.Helpers.Slugify(slugifySource); affix = 1; tempSlug = slugify
      slugify = tempSlug + ++affix while Document[source].findOne({slug: slugify})
      slugify