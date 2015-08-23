((app) ->
  app.headerView = (ctrl) ->
    m 'header', [
      m 'nav', [
        m '.logo', [
          m 'span.logo__primary', 'funko'
          m 'span.logo__secondary', 'llect.io'
        ]
        m 'ul', [
          m 'li', m 'a[href=/]', { config: m.route, className: if not ctrl.filter() then 'link--active' else '' }, '#all (' + (if ctrl.filter() then app.storage.products().length else ctrl.products().hits) + ')'
          m 'li', m 'a[href=/owned]', { config: m.route, className: if ctrl.filter() is 'owned' then 'link--active' else '' }, '#owned (' + app.storage.owned().length + ')'
          m 'li', m 'a[href=/need]', { config: m.route, className: if ctrl.filter() is 'need' then 'link--active' else '' }, '#need (' + app.storage.need().length + ')'
        ]
      ]

      m '.header__right', [
        m 'a[target="_blank"][class="link--border"]', { href: 'https://twitter.com/home?status=Have%20fun%20managing%20your%20funko%27s%20funky%20pop%20collection.%20' + ctrl.getShareUrl() + '%20via%20%40zh0uzi%20%23funko%20%23collection' }, [
          m 'span.icon-twitter'
          m 'span', 'Share'
        ]

        m 'a[href="https://github.com/Zhouzi/funkollect.io"][class="link--border"]', [
          m 'span.icon-github'
          m 'span', 'Contribute'
        ]
      ]
    ]
)(@app)