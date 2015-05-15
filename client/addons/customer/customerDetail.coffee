Wings.defineWidget 'customerDetail',
  events:
    "click .customer-image": (event, template) -> template.find(".customer-image-input").click()
    "change .customer-image-input": (event, template) ->
      instance = @instance
      files = event.target.files
      if files.length > 0
        Storage.CustomerImage.insert files[0], (error, fileObj) ->
          if error
            console.log 'avatar image upload error', error
          else
            Storage.CustomerImage.findOne(instance.image)?.remove()
            Document.Customer.update instance._id, $set: {image: fileObj._id}
    "click .customer-image .clear": (event, template) ->
      Storage.CustomerImage.findOne(@instance.image)?.remove()
      Document.Customer.update @instance._id, $unset: {image: ""}
      event.stopPropagation()

    "click .update-customer": (event, template) ->
      businessOwner  = $(template.find(".businessOwner input")).val()
      companyPhone   = $(template.find(".companyPhone input")).val()
      companyAddress = $(template.find(".companyAddress input")).val()

      updateCustomer = {}
      updateCustomer.businessOwner  = businessOwner if @instance.businessOwner isnt businessOwner
      updateCustomer.companyPhone   = companyPhone if @instance.companyPhone isnt companyPhone
      updateCustomer.companyAddress = companyAddress if @instance.companyAddress isnt companyAddress

      @instance.update(updateCustomer)