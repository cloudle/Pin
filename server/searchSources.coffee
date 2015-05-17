#SearchSource.defineSource 'products', (searchText, options) ->
#  options = {sort: {isoScore: -1}, limit: 5}
#
#  if searchText
#    regExp = buildRegExp(searchText)
#    return Document.Product.find({name: regExp}).fetch()
#  else
#    return Document.Product.find({}, options).fetch()
#
#buildRegExp = (searchText) ->
#  parts = searchText.trim().split(/[ \-\:]+/);
#  return new RegExp("(" + parts.join('|') + ")", "ig");