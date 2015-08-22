((app) ->
  app.view = (ctrl) ->
    if ctrl.products().products.length
      mainView = app.productsView
    else
      if ctrl.filter() is 'owned' and not app.storage.owned().length
        mainView = app.ownedBlankView
      else if ctrl.filter() is 'need' and not app.storage.need().length
        mainView = app.needBlankView
      else # there are products in this collection but the current search doesn't match any of them
        mainView = app.noResultsView

    m 'main', [
      app.headerView ctrl
      m 'section', [
        mainView ctrl
        m '.block.link', { onclick: ctrl.showMore.bind ctrl }, 'load more results' if ctrl.products().hits > ctrl.limit()
      ]
    ]
)(@app)