checkProductInStockQuality = (orderDetails)->
  details = _.chain(orderDetails)
  .groupBy("product")
  .map (group, key) ->
    return {
      product      : group[0].product
      basicQuality : _.reduce( group, ((res, current) -> res + current.basicQuality), 0 )
    }
  .value()

  result = {valid: true, errorItem: []}
  if details.length > 0
    for currentDetail in details
      currentProduct = Document.Product.findOne(currentDetail.product)
      console.log currentProduct.qualities
#      if currentProduct.qualities[0].availableQuality < currentDetail.basicQuality
#        result.errorItem.push detail for detail in _.where(orderDetails, {product: currentDetail.product})
#        (result.valid = false; result.message = "sản phẩm không đủ số lượng") if result.valid
  else
    result = {valid: false, message: "Danh sách sản phẩm trống." }

  return result

subtractQualityOnSales = (importDetails, saleDetail) ->
  transactionQuality = 0
  for importDetail in importDetails
    requiredQuality = saleDetail.basicQuality - transactionQuality
    takenQuality = if importDetail.availableQuality > requiredQuality then requiredQuality else importDetail.availableQuality

    updateProduct = {availableQuality: -takenQuality, inStockQuality: -takenQuality, saleQuality: takenQuality}
    Schema.Product.update importDetail.product, $inc: updateProduct
    Schema.BranchProduct.update importDetail.branchProduct, $inc: updateProduct
    Schema.ImportDetail.update importDetail._id, $inc: updateProduct, $push:{saleDetail: {id:saleDetail._id, quality: takenQuality}}
    Schema.SaleDetail.update saleDetail._id, $set:{status: "submit"}, $push:{importDetail: {id:importDetail._id, quality: takenQuality}}

    transactionQuality += takenQuality
    if transactionQuality == saleDetail.basicQuality then break

  return transactionQuality == saleDetail.basicQuality

Meteor.methods
  orderSubmit: (orderId) ->
    orderFound = Document.Order.findOne(orderId)
    return if orderFound.orderType isnt Enum.orderType.created

    result = checkProductInStockQuality(orderFound.details)
    console.log result