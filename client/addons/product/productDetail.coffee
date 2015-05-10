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
      baseUnitName = $(template.find(".baseUnitName input")).val()
      salePrice    = accounting.parse $(template.find(".salePrice input")).val()
      importPrice  = accounting.parse $(template.find(".importPrice input")).val()

      updateOption = {}
      updateOption.name        = baseUnitName if @instance.baseUnitName isnt baseUnitName
      updateOption.salePrice   = salePrice if @instance.salePrice isnt salePrice
      updateOption.importPrice = importPrice if @instance.importPrice isnt importPrice
      if @instance.baseUnit then @instance.updateBaseUnit updateOption else @instance.insertBaseUnit updateOption


    "click .extract-unit": (event, template) ->
      $baseUnit = $(template.find(".baseUnitName"))
      $baseUnitInput = $(template.find(".baseUnitName input"))
      baseUnit = $baseUnitInput.val()
      if !@instance.useAdvancePrice and !baseUnit
        $baseUnitInput.focus()
        Wings.SiderAlert.show $baseUnit, "Bạn phải <b>xác định đơn vị tính cơ bản</b> để thêm mới đơn vị tính <b>mở rộng</b>!", $baseUnitInput
      else if !@instance.useAdvancePrice
#        Document.Product.update(@instance._id, {$set: {useAdvancePrice: true, baseUnit: baseUnit}})
      else
        Session.set("showProductUnitCreatePane", true)

    "click .add-unit": (event, template) ->
      $unitName   = $(template.find(".insertUnitName input"))
      $conversion = $(template.find(".insertConversion input"))
      $salePrice  = $(template.find(".insertSalePrice input"))

      newUnit = {}
      newUnit.name       = $unitName.val()
      newUnit.conversion = accounting.parse $conversion.val()
      newUnit.salePrice  = accounting.parse $salePrice.val()

      @instance.insertUnit newUnit


#      if !@instance.useAdvancePrice and !@instance.baseUnit
#        $baseUnitInput.focus()
#        Wings.SiderAlert.show $baseUnitName, "Bạn phải <b>xác định đơn vị tính cơ bản</b> để thêm mới đơn vị tính <b>mở rộng</b>!", $unitNameInput
#      else if !@instance.useAdvancePrice
#
#
#        if _.contains(_.pluck(@instance.units, 'name'), insertUnit.name)
#          $unitNameInput.focus()
#          Wings.SiderAlert.show $baseUnitName, "<b>Đơn vị tính mới</b> đã trùng bị trùng tên!", $unitNameInput
#        else
#          @instance.insertUnit insertUnit
#
#      else
#        Session.set("showProductUnitCreatePane", true)