((app) ->
  try
    s = JSON.parse localStorage.getItem('funkollect.io') || '{}'
  catch e
    s = {}

  today = ((now) ->
    month = now.getUTCMonth()
    day = now.getUTCDate()
    year = now.getUTCFullYear()

    year + '-' + month + '-' + day
  )(new Date)

  app.storage =
    products: m.prop []
    counters: m.prop { all: 0 }
    owned: m.prop s.owned || []
    need: m.prop s.need || []
    viewed: m.prop s.viewed || {}
    save: () -> localStorage.setItem 'funkollect.io', JSON.stringify { owned: @owned(), need: @need(), viewed: @viewed() }

    isViewed: (product) ->
      for day, products of @viewed()
        return true if products.indexOf(product.id) > -1

      false

    clearHistory: (today) ->
      today = new Date today
      day = 86400000
      limit = day * 3
      viewed = @viewed()
      clearedViewed = {}

      for day, products of viewed
        clearedViewed[day] = products if today.getTime() - new Date(day).getTime() < limit

      @viewed clearedViewed
      @save()

    setViewed: (products) ->
      viewed = @viewed()
      viewed[today] = [] if not viewed[today]
      viewed[today] = viewed[today].concat products.map((product) -> product.id).filter (id) -> viewed[today].indexOf(id) < 0
      @save()

  app.storage.clearHistory(today)

  m.request({ method: 'GET', url: 'products.json' }).then (products) ->
    app.storage.products products.map (product) ->
      app.storage.counters().all++

      if not app.storage.counters()[product.license]?
        app.storage.counters()[product.license] =
          total: 0
          owned: 0
          need: 0

      app.storage.counters()[product.license].total++
      app.storage.counters()[product.license].owned++ if app.storage.owned().indexOf(product.id) > -1
      app.storage.counters()[product.license].need++ if app.storage.need().indexOf(product.id) > -1

      new app.Product product
)(@app)