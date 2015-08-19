((app) ->
  app.view = (ctrl) ->
    m 'main', [
      app.headerView ctrl
      m 'section',
        if ctrl.products().products.length then app.productsView ctrl else if ctrl.filter() is 'owned' then app.ownedBlankView ctrl else if ctrl.filter() is 'need' then app.needBlankView ctrl
        m '.block.link', { onclick: ctrl.showMore.bind ctrl }, 'load more results' if ctrl.products().hits > ctrl.limit()
    ]
)(@app)