((app) ->
  m.route.mode = 'hash'
  app.router = m.route document.getElementById('app'), '/',
    '/': app
    '/:filter': app
)(@app)