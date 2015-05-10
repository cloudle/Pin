Wings.defineWidget 'productDetail',
  rendered: -> "re-render!"
  destroyed: -> Session.set("showProductUnitCreatePane")

  events:
    "click .product-image": (event, template) -> template.find(".product-image-input").click()
    "change .product-image-input": (event, template) ->
      instance = @instance
      files = event.target.files
      if files.length > 0
        Storage.ProductImage.insert files[0], (error, fileObj) ->
          if error
            console.log 'avatar image upload error', error
          else
            Storage.ProductImage.findOne(instance.image)?.remove()
            Document.Product.update instance._id, $set: {image: fileObj._id}

    "click .product-image .clear": (event, template) ->
      Storage.ProductImage.findOne(@instance.image)?.remove()
      Document.Product.update @instance._id, $unset: {image: ""}
      event.stopPropagation()

    "click .save-price": (event, template) ->
      baseUnit    = $(template.find(".baseUnit input")).val()
      salePrice   = accounting.parse $(template.find(".salePrice input")).val()
      importPrice = accounting.parse $(template.find(".importPrice input")).val()
      Document.Product.update @instance._id, $set: {price: salePrice, importPrice: importPrice, baseUnit: baseUnit}

    "click .add-unit": (event, template) ->
      $baseUnit = $(template.find(".baseUnit"))
      $baseUnitInput = $(template.find(".baseUnit input"))
      baseUnit = $baseUnitInput.val()
      if !@instance.useAdvancePrice and !baseUnit
        $baseUnitInput.focus()
        Wings.SiderAlert.show $baseUnit, "Bạn phải <b>xác định đơn vị tính cơ bản</b> để thêm mới đơn vị tính <b>mở rộng</b>!", $baseUnitInput
      else if !@instance.useAdvancePrice
        Document.Product.update(@instance._id, {$set: {useAdvancePrice: true, baseUnit: baseUnit}})
      else
        Session.set("showProductUnitCreatePane", true)