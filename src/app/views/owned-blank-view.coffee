((app) ->
  app.ownedBlankView = (ctrl) ->
    m '.block', [
      m 'span', 'It looks like you don\'t own any products yet. To find a store, have look at Funko\'s '
      m 'a[href="http://funko.com/apps/store-locator"][target="_blank"][class="link--border"]', 'store locator'
      m 'span', '.'
    ]
)(@app)