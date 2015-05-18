formatProductSearch = (item) -> "#{item.name} - #{item.unitName}" if item
productUnits = ()->
  units = []; units.push(product.productUnits) for product in Document.Product.find().fetch()
  _.flatten(units)

getSalePrice = (productUnitId) ->
  product = Document.Product.findOne({'units._id': productUnitId})
  productUnit = _.findWhere(product.productUnits, {_id: productUnitId})
  productUnit.salePrice

productSelectOptions =
  query: (query) -> query.callback
    results: _.filter productUnits(), (item) ->
      unsignedTerm = Wings.Helpers.Slugify(query.term)
      unsignedName = Wings.Helpers.Slugify(item.name)
      unsignedName.indexOf(unsignedTerm) > -1
    text: 'name'

  initSelection: (element, callback) -> callback(productUnits[0])
  reactiveValueGetter: -> Session.get('currentOrder')?.buyer
  formatSelection: formatProductSearch
  formatResult: formatProductSearch
  placeholder: 'CHỌN SẢN PHẨM'
  changeAction: (e) ->
    productUnit = {_id: e.added._id, quality: 1, price: getSalePrice(e.added._id)}
    $(".productQuality input").val(productUnit.quality)
    $(".unitPrice input").val(accounting.format productUnit.price)
    Session.set('currentProductUnit', productUnit)

Wings.defineWidget 'orderDetail',
  helpers:
    productSelectOptions: productSelectOptions
    hasProductUnits: -> @productUnits?.length > 0
    finalPrice: -> @price * @quality

#    getProducts: ->
#      ProductSearch.getData
#        transform: (matchText, regExp) -> matchText.replace(regExp, "<b>$&</b>")
#        sort: {isoScore: -1}

  rendered: -> Session.set("currentProduct", Document.Product.findOne({}))
  events:
#    "wings-change .productQuality": (event, template, value) ->
#      $salePrice = $(template.find(".unitPrice input"))
#      $salePrice.val(accounting.format(Session.get('currentProductUnit').price * value))
    "keyup": (event, template) ->
      details = Template.currentData().instance.details
      editingId = Session.get("editingId")
      if event.which is 27
        Session.set("editingId")

    "click .add-order-detail" : (event, template) ->
      unitId      = Session.get('currentProductUnit')._id
      unitQuality = accounting.parse $(template.find(".productQuality input")).val()
      unitPrice   = accounting.parse $(template.find(".unitPrice input")).val()
      @instance.addDetail(unitId, unitQuality, unitPrice)

    "click .detail-row": (event, template) ->
      Session.set("editingId", @_id)
      event.stopPropagation()

    "click .remove.order-row": (event, template) ->
      window.preventResetEditing = true
      order = template.data.instance
      order.removeDetail(@_id)

    "navigate .wings-tab": (event, template, instance) -> Wings.go('order', instance.slug)
    "insert-command .wings-tab": (event, template) -> console.log 'insert command'
    "remove-command .wings-tab": (event, template, instance) ->
      console.log instance