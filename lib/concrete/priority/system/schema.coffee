Module "Wings.Schema",
#  Essential: new SimpleSchema
#    creator: { type: Wings.Schema.creator }
#    version: { type: Wings.Schema.version }

  creator:
    type: String
    autoValue: -> Meteor.userId() if @isInsert and not @isSet

  version: new SimpleSchema
    createdAt:
      type: Date
      autoValue: ->
        if @isInsert
          return new Date
        else if @isUpsert
          return { $setOnInsert: new Date }

    updateAt:
      type: Date
      autoValue: ->
        return new Date() if @isUpdate
      denyInsert: true
      optional: true

  slugify: (source, field = 'name') ->
    type: String
    autoValue: ->
      return if !@isInsert or !slugifySource = @field(field)?.value
      slugify = Wings.Helpers.Slugify(slugifySource); affix = 1; tempSlug = slugify
      slugify = tempSlug + ++affix while Document[source].findOne({slug: slugify})
      slugify