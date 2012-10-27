describe "Route", ->

  Route = Monocle.Route
  RouteOptions = Route.options


  navigate = ->
    args = (if 1 <= arguments.length then [].slice.call(arguments, 0) else [])
    changed = false
    $.Deferred((dfd) ->
      Route.bind "change", -> changed = true

      Route.navigate.apply Route, args
      waitsFor ->
        changed is true

      runs ->
        dfd.resolve()

    ).promise()


  beforeEach ->
    Route.options = RouteOptions

  afterEach ->
    Route.unbind()
    Route.routes = []
    delete Route.path

  it "should not have bound any hashchange|popstate event to window", ->
    events = Monocle.Dom(window).data("events") or {}
    expect("hashchange" of events or "popstate" of events).toBe false


  it "can set its path", ->
    expect(Route.path).toBeUndefined()
    Route.change()
    expect(Route.path).toBeDefined()


  it "can add a single route", ->
    Route.add "/foo"
    expect(Route.routes.length).toBe 1


  it "can add a bunch of routes", ->
    Route.add
      "/foo": ->
      "/bar": ->

    expect(Route.routes.length).toBe 2


  it "can add regex route", ->
    Route.add /\/users\/(\d+)/
    expect(Route.routes.length).toBe 1


  it "should trigger 'change' when a route matches", ->
    changed = 0
    Route.bind "change", -> changed += 1

    Route.add "/foo", ->
    Route.navigate "/foo"

    waitsFor ->
      changed > 0

    runs ->
      expect(changed).toBe 1


  it "can navigate to path", ->
    Route.add "/users", ->

    navigate("/users").done ->
      expect(Route.path).toBe "/users"


  it "can navigate to a path splitted into several arguments", ->
    Route.add "/users/1/2", ->

    navigate("/users", 1, 2).done ->
      expect(Route.path).toBe "/users/1/2"
