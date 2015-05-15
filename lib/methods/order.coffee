Meteor.methods
  orderSubmit: (orderId) ->
#    orderFound = Document.Order.findOne(orderId)
#    return if orderFound.orderType isnt Enum.orderType.created
#
#    updateOrder  = {$set:{orderType: Enum.orderType.submitted}}
#    updateProduct = {$set:{totalPrice: 0}}
#
#    for detail, detailIndex in orderFound.details
#      product = Document.Product.findOne({'units._id': detail.productUnit})
#      return console.log('Khong tim thay Product') if !product
#      productUnit = _.findWhere(product.units, {_id: detail.productUnit})
#      return console.log('Khong tim thay ProductUnit') if !productUnit
#      productUnitIndex = _.indexOf(product.units, productUnit)
#      updateProduct.$set['units.'+[productUnitIndex]+'.allowDelete'] = false
#
#      updateOrder.$set.totalPrice += detail.quality * detail.price
#      baseQuality = productUnit.conversion * detail.quality
#      updateOrder.$set['details.'+detailIndex+'.availableQuality']    = baseQuality
#      updateOrder.$set['details.'+detailIndex+'.inStockQuality']      = baseQuality
#      updateOrder.$set['details.'+detailIndex+'.orderQuality']       = baseQuality
#
#      #      productQuality = _.findWhere(product.qualities, {branch: ????}) khi co Branch
#      #      qualityIndex = _.indexOf(product.qualities, productQuality)
#      productQuality = product.qualities[0]
#      qualityIndex = 0
#      updateProduct.$set['qualities.'+qualityIndex+'.availableQuality']    = baseQuality + productQuality.availableQuality
#      updateProduct.$set['qualities.'+qualityIndex+'.inStockQuality']      = baseQuality + productQuality.inStockQuality
#      updateProduct.$set['qualities.'+qualityIndex+'.orderQuality']       = baseQuality + productQuality.orderQuality
#      Document.Product.update(product._id, updateProduct)
#
#    updateOrder.$set.finalPrice = updateOrder.$set.totalPrice - detail.discountCash
#    Document.Order.update(orderFound._id, updateOrder)

