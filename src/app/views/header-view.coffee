((app) ->
  app.headerView = (ctrl) ->
    m 'header', [
      m 'nav', [
        m '.logo', [
          m 'span.logo__primary', 'funko'
          m 'span.logo__secondary', 'llect.io'
        ]
        m 'ul', [
          m 'li', m 'a[href=#/]', { className: if not ctrl.filter() then 'link--active' else '' }, '#all (' + ctrl.products().hits + ')'
          m 'li', m 'a[href=#/owned]', { className: if ctrl.filter() is 'owned' then 'link--active' else '' }, '#owned (' + app.storage.owned().length + ')'
          m 'li', m 'a[href=#/need]', { className: if ctrl.filter() is 'need' then 'link--active' else '' }, '#need (' + app.storage.need().length + ')'
        ]
      ]
      m 'form', { onsubmit: ctrl.search.bind ctrl }, [
        m 'a[href="https://twitter.com/home?status=Have%20fun%20managing%20your%20funko%27s%20funky%20pop%20collection.%20http%3A%2F%2Ffunkollect.io%20via%20%40zh0uzi%20%23funko%20%23collection"][target="_blank"]', 'share'
        m 'a[href="https://twitter.com/home?status=Have%20feedback%3F%20Wanna%20submit%20a%20feature%3F%20Report%20a%20bug%3F%20Get%20in%20touch%20%40zh0uzi"][target="_blank"]', 'contact'
        m 'a[href="https://github.com/Zhouzi/funkollect.io"]', 'contribute'
        m 'input[type="text"][placeholder="Search..."]', { onchange: m.withAttr('value', ctrl.queryInput), value: ctrl.queryInput() }
        m 'button[type="submit"]', [
          m 'span[class="icon-search"]'
        ]
      ]
    ]
)(@app)