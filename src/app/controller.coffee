((app) ->
  ITEMS_PER_PAGE = 12

  app.controller = class
    constructor: () ->
      @filter = m.prop m.route.param('filter') || ''
      @counters = app.storage.counters
      @limit = m.prop ITEMS_PER_PAGE
      @queryInput = m.prop ''
      @query = m.prop ''

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

    products: () ->
      query = @query().split(':').map (val) -> val.trim()

      if query.length is 1
        term = query[0]
        field = 'title'
      else
        term = query[1]
        field = query[0]

      products = app.storage.products().filter (product) -> product[field].toLowerCase().indexOf(term.toLowerCase()) > -1

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
      @limit ITEMS_PER_PAGE

      if typeof event == 'string'
        if @query() isnt event
          @query event
          @queryInput event
        else
          @query ''
          @queryInput ''
      else
        @query @queryInput()
        event.preventDefault()

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