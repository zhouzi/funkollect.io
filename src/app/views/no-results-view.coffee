((app) ->
  app.noResultsView = (ctrl) ->
    m '.block', 'Too bad, there are no results matching your query :/'
)(@app)