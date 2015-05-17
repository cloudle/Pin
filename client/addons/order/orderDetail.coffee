formatProductSearch = (item) -> "#{item.name} - #{item.unitName}" if item
productUnits = ()->
  units = []
  for product in Document.Product.find().fetch()
    units.push(product.productUnits)
  _.flatten(units)

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
  changeAction: (e) -> console.log e

Wings.defineWidget 'orderDetail',
  helpers:
    productSelectOptions: productSelectOptions
    hasProductUnits: -> @productUnits?.length > 0
    finalPrice: -> @price * @quality
    orderInfo: ->
      product = Document.Product.findOne({"units._id": @productUnit})
      return {} if !product
      productUnit = _.findWhere(product.units, {_id: @productUnit})
      product: product
      unit: productUnit

#    getProducts: ->
#      ProductSearch.getData
#        transform: (matchText, regExp) -> matchText.replace(regExp, "<b>$&</b>")
#        sort: {isoScore: -1}

  rendered: -> Session.set("currentProduct", Document.Product.findOne({}))
  events:
    "change .selectProduct" : (event, template) ->
      productId = template.find('.selectProduct').value
      product
      Session.set "currentProduct", Document.Product.findOne(productId)
    "click .remove.order-row": (event, template) ->
      order = template.data.instance
      order.removeDetail(@_id)