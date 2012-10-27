class Monocle.Route extends Monocle.Module

  @extend Monocle.Events

  @historySupport: window.history?.pushState?

  @routes: []

  @options:
    trigger: true
    history: false

  @listen: (options = {}) ->
    @options = @extend @options, options
    if @options.history
      @history = @historySupport && @options.history

    Monocle.Dom(window).bind(@getEventName(), @change)
    @change()

  @add: (path, callback) ->
    if (typeof path is 'object' and path not instanceof RegExp)
      @add(key, value) for key, value of path
    else
      @routes.push(new @(path, callback))

  @unbind: -> Monocle.Dom(window).unbind(@getEventName(), @change)

  @navigate: (args...) ->
    options = {}
    last_argument = args[args.length - 1]
    if typeof last_argument is 'object'
      options = args.pop()
    else if typeof last_argument is 'boolean'
      options.trigger = args.pop()
    options = @extend @options, options

    path = args.join('/')
    unless path is @path
      @path = path
      @trigger('navigate', @path)
      @matchRoute(@path, options) if options.trigger

      if @history
        history.pushState {}, document.title, @path
      else
        window.location.hash = @path

    return @

  # Private
  @extend: (object={}, properties) ->
    object[key] = val for key, val of properties
    object

  @getEventName: -> if @history then "popstate" else "hashchange"

  @getPath: ->
    path = window.location.pathname
    if path.substr(0,1) isnt '/'
      path = '/' + path
    path

  @getFragment: -> @getHash().replace(hashStrip, '')

  @getHost: -> (document.location + '').replace(@getPath() + @getHash(), '')

  @getHash: -> window.location.hash

  @change: ->
    path = if @history then @getPath() else @getFragment()
    unless path is @path
      @path = path
      @matchRoute(@path)
    @

  @matchRoute: (path, options) ->
    for route in @routes
      if route.match(path, options)
        @trigger('change', route, path)
        return route

  constructor: (@path, @callback) ->
    @names = []

    if typeof path is 'string'
      namedParam.lastIndex = 0
      while (match = namedParam.exec(path)) != null
        @names.push(match[1])

      splatParam.lastIndex = 0
      while (match = splatParam.exec(path)) != null
        @names.push(match[1])

      path = path.replace(escapeRegExp, '\\$&')
                 .replace(namedParam, '([^\/]*)')
                 .replace(splatParam, '(.*?)')

      @route = new RegExp('^' + path + '$')
    else
      @route = path

  match: (path, options = {}) ->
    match = @route.exec(path)

    return false unless match

    options.match = match
    if @names.length
      for param, i in match.slice(1)
        options[@names[i]] = param

    @callback.call(null, options) isnt false

# Regular expressions
hashStrip    = /^#*/
namedParam   = /:([\w\d]+)/g
splatParam   = /\*([\w\d]+)/g
escapeRegExp = /[-[\]{}()+?.,\\^$|#\s]/g

# Coffee-script bug
Monocle.Route.change = Monocle.Route.proxy(Monocle.Route.change)

Monocle.Controller.include
  route: (path, callback) -> Monocle.Route.add path, @proxy(callback)

  routes: (routes) -> @route(key, value) for key, value of routes

  url: -> Monocle.Route.navigate.apply(Monocle.Route, arguments)
