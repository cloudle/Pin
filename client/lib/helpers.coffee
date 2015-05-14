Template.registerHelper 'applicationCollapseClass', -> if Session.get("kernelAddonVisible") then 'collapse' else 'expand'

Template.registerHelper 'productImageSrc', (imageId) -> Storage.ProductImage.findOne(imageId)?.url()
Template.registerHelper 'userImageSrc', (imageId) -> Storage.UserImage.findOne(imageId)?.url()
Template.registerHelper 'customerImageSrc', (imageId) -> Storage.CustomerImage.findOne(imageId)?.url()

Template.registerHelper 'missingImageClass', (imageId) -> if !imageId then 'missing' else ''
Template.registerHelper 'avatarLetter', (source) -> source.substr(0, 1).toUpperCase()


Template.registerHelper 'formatNumber', (source) -> accounting.format(source)

Template.registerHelper 'standardDate', (source) -> moment(source).format("DD/MM/YYYY")