Wings.defineWidget 'staffDetail',
  events:
    "click .user-image": (event, template) -> template.find(".user-image-input").click()
    "change .user-image-input": (event, template) ->
      instance = @instance
      files = event.target.files
      if files.length > 0
        Storage.UserImage.insert files[0], (error, fileObj) ->
          if error
            console.log 'avatar image upload error', error
          else
            Storage.UserImage.findOne(instance.image)?.remove()
            console.log 'before error'
            Document.Staff.update instance._id, $set: {image: fileObj._id}
            console.log 'done'
    "click .user-image .clear": (event, template) ->
      Storage.UserImage.findOne(@instance.image)?.remove()
      Document.Staff.update @instance._id, $unset: {image: ""}
      event.stopPropagation()