((app) ->
  s = JSON.parse localStorage.getItem('funkollect.io') || '{}'

  app.storage =
    products: m.prop []
    counters: m.prop { all: 0 }
    owned: m.prop s.owned || []
    need: m.prop s.need || []
    save: () -> localStorage.setItem 'funkollect.io', JSON.stringify { owned: @owned(), need: @need() }

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