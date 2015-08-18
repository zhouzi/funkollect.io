((app) ->
  app.view = (ctrl) ->
    m 'main', [
      app.headerView ctrl
      m 'section',
        if ctrl.products().length then app.productsView ctrl else if ctrl.filter() is 'owned' then app.ownedBlankView ctrl else if ctrl.filter() is 'need' then app.needBlankView ctrl
    ]
)(@app)