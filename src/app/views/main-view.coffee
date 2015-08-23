((app) ->
  app.view = (ctrl) ->
    hasResults = true

    if ctrl.products().products.length
      mainView = app.productsView
    else
      if ctrl.filter() is 'owned' and not app.storage.owned().length
        mainView = app.ownedBlankView
        hasResults = false
      else if ctrl.filter() is 'need' and not app.storage.need().length
        mainView = app.needBlankView
        hasResults = false
      else # there are products in this collection but the current search doesn't match any of them
        mainView = app.noResultsView

    m 'main', [
      app.headerView ctrl

      m '.actions', [
        m '.actions__left', [
          m 'form.search-form', { onsubmit: ctrl.search.bind ctrl }, [
            m 'input[type="text"][placeholder="Search..."]', { value: ctrl.queryInput(), onchange: m.withAttr 'value', ctrl.queryInput }
            m 'button[type="submit"]', [
              m 'span[class="icon-search"]'
            ]
          ]

          m 'span.link', { onclick: ctrl.clearSearch.bind ctrl }, 'Clear' if ctrl.hasQuery()
        ]

        m '.actions__right', [
          m 'button[type="button"]', { onclick: ctrl.shuffle.bind ctrl }, [
            m 'span.icon-shuffle'
            m 'span', 'Shuffle'
          ]
        ]
      ] if hasResults

      m 'section', [
        mainView ctrl
        m '.block.link', { onclick: ctrl.showMore.bind ctrl }, 'load more results' if ctrl.products().hits > ctrl.limit()
      ]
    ]
)(@app)