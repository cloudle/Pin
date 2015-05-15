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
    products: -> Document.Product.find({})
    hasProductUnits: -> @productUnits?.length > 0

    productName: ->
      product = Document.Product.findOne()
      productUnit = _.findWhere(product.units, {_id: @productUnit})
      product.name + (productUnit.name)

  rendered: -> Session.set("currentProduct", Document.Product.findOne({}))
  events:
    "change .selectProduct" : (event, template) ->
      productId = template.find('.selectProduct').value
      product
      Session.set "currentProduct", Document.Product.findOne(productId)