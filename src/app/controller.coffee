((app) ->
  ITEMS_PER_PAGE = 12

  app.controller = class
    constructor: () ->
      @filter = m.prop m.route.param('filter') || ''
      @counters = app.storage.counters
      @limit = m.prop ITEMS_PER_PAGE
      @queryInput = m.prop ''
      @query = m.prop { query: '', field: 'title' }

    bindInfiniteScroll: (element, isInitialized, context) ->
      if not isInitialized
        infiniteScrollListener = window.addEventListener 'scroll', () =>
          body = document.body
          html = document.documentElement
          scrollPosition = Math.max(body.scrollTop, html.scrollTop) + (html.clientHeight || window.innerHeight)
          height = Math.max body.scrollHeight, body.offsetHeight, html.scrollHeight, html.offsetHeight

          if scrollPosition >= (height - (height / 6))
            @showMore()
            m.redraw true
        , false

        context.onunload = () -> window.removeEventListener 'scroll', infiniteScrollListener, false

    showMore: () ->
      currentLimit = @limit()

      if currentLimit < @products().hits
        @limit currentLimit += ITEMS_PER_PAGE

    satisfiesQuery: (product, field, query) ->
      field = @query().field if not field
      query = @query().query if not query

      product[field].toLowerCase().indexOf(query) > -1

    products: () ->
      terms = @query()
      query = terms.query
      field = terms.field || 'title'

      products = app.storage.products().filter (product) =>
        @satisfiesQuery(product, field, query)

      filter = @filter()

      if filter is 'owned'
        products = products.filter (product) -> product.owned() is true
      else if filter is 'need'
        products = products.filter (product) -> product.need() is true

      {
        products: products.slice 0, @limit()
        hits: products.length
      }

    search: (event) ->
      event.preventDefault && event.preventDefault()

      terms = (if typeof event is 'string' then event else @queryInput()).split ':'
      query = (terms.pop() || '').trim().toLowerCase()
      field = (terms.shift() || '').trim()

      # If event is a string, meaning it is manually set and doesn't come from the search form
      # And the query is the same as the current one (same query, same field), then clear it to display all results
      # It actually acts as a toggle when clicking a product's license
      if typeof event is 'string' and query is @query().query and field is @query().field
        query = ''
        field = ''

      inputValue = if field then field + ': ' + query else query
      @queryInput inputValue

      @query { query: query, field: field }
      @limit ITEMS_PER_PAGE

    need: (product, isNeed) ->
      index = app.storage.need().indexOf product.id

      if isNeed
        if index < 0
          app.storage.need().push product.id
          app.storage.counters()[product.license].need++
      else
        if index > -1
          app.storage.need().splice index, 1
          app.storage.counters()[product.license].need--

      product.need isNeed

    owned: (product, isOwned) ->
      index = app.storage.owned().indexOf product.id

      if isOwned
        if index < 0
          app.storage.owned().push product.id
          app.storage.counters()[product.license].owned++
      else
        if index > -1
          app.storage.owned().splice index, 1
          app.storage.counters()[product.license].owned--

      product.owned isOwned

    toggleNeed: (product) ->
      @need product, !product.need()
      @owned product, false if product.need()
      app.storage.save()

    toggleOwned: (product) ->
      @owned product, !product.owned()
      @need product, false if product.owned()
      app.storage.save()
)(@app)