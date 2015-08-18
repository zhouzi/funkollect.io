((app) ->
  app.Product = class
    constructor: (product) ->
      for prop, value of product
        @[prop] = value

      @owned = m.prop app.storage.owned().indexOf(@id) > -1
      @need = m.prop app.storage.need().indexOf(@id) > -1
)(@app)