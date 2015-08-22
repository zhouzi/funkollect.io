((app) ->
  app.productsView = (ctrl) ->
    hasQuery = !!ctrl.query().query

    loadHighRes = (element, isInitialized) ->
      if not isInitialized
        src = element.getAttribute 'src'
        element.setAttribute 'src', src.replace /\/s\//g, '/'

    ctrl.products().products.map (product) ->
      m 'article.article', { key: product.id, className: if product.owned() then 'article--owned' else if product.need() then 'article--need' else '' }, [
        m '.article__inner', [
          m '.article__image', [
            m '.article__image__mock'
            m 'img', { config: loadHighRes, src: 'public/images/s/' + product.id + '.png' }
          ]
          m '.article__footer', [
            m 'h2', product.name
            m 'h3', [
              m 'a.article__license', { className: (if hasQuery and ctrl.satisfiesQuery product, 'license' then 'article__license--active' else ''), onclick: ctrl.search.bind ctrl, 'license: ' + product.license }, product.license
              m 'small.article__stats', '(total: ' + ctrl.counters()[product.license].total + ', owned: ' + ctrl.counters()[product.license].owned + ', need: ' + ctrl.counters()[product.license].need + ')'
            ]
            m 'div.article__actions', [
              m 'button', {
                type: 'button'
                className: if product.need() then 'button--active' else if product.owned() then 'button--disabled' else ''
                onclick: ctrl.toggleNeed.bind ctrl, product
              }, 'need'
              m 'button', {
                type: 'button'
                className: if product.owned() then 'button--active' else if product.need() then 'button--disabled' else ''
                onclick: ctrl.toggleOwned.bind ctrl, product
              }, 'owned'
            ]
          ]
        ]
      ]
)(@app)