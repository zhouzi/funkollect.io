((app) ->
  app.productsView = (ctrl) ->
    ctrl.products().map (product) ->
      m 'article.article', { className: if product.owned() then 'article--owned' else if product.need() then 'article--need' else '' }, [
        m 'div.article__inner', [
          m '.article__image', [
            m 'img', { src: 'public/images/' + product.id + '.png' }
          ]
          m '.article__footer', [
            m 'h2', product.name
            m 'h3', [
              m 'span.article__license', product.license
              m 'small', '(' + ctrl.counters()[product.license].owned + '/' + ctrl.counters()[product.license].total + ' owned)'
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