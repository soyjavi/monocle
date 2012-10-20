describe "Model", ->
  Asset = undefined

  beforeEach ->
    class Instance extends Monocle.Model
    Asset = Instance.fields(["name"])

  it "can create records", ->
    asset = Asset.create name: "test.pdf"
    expect(Asset.all()[0]).toEqual asset


  it "can update records", ->
    asset = Asset.create(name: "test.pdf")
    expect(Asset.all()[0].name).toEqual "test.pdf"
    asset.name = "wem.pdf"
    asset.save()
    expect(Asset.all()[0].name).toEqual "wem.pdf"


  it "can destroy records", ->
    asset = Asset.create(name: "test.pdf")
    expect(Asset.all()[0]).toEqual asset
    asset.destroy()
    expect(Asset.all()[0]).toBeFalsy()


  it "can find records", ->
    asset = Asset.create(name: "test.pdf")
    expect(Asset.find(asset.uid)).toBeTruthy()
    asset.destroy()

    expect(->
      Asset.find asset.uid
    ).toThrow()


  it "can find records by attribute", ->
    asset = Asset.create name: "test.pdf"
    expect(Asset.findBy("name", "test.pdf")).toBeTruthy()
    asset.destroy()

    expect(->
      Asset.findBy "name", "test.pdf"
    ).toThrow()


  it "can check existence", ->
    asset = Asset.create name: "test.pdf"
    expect(asset.exists()).toBeTruthy()
    expect(Asset.exists(asset.uid)).toBeTruthy()
    asset.destroy()
    expect(asset.exists()).toBeFalsy()
    expect(Asset.exists(asset.id)).toBeFalsy()


  it "can select records", ->
    asset1 = Asset.create(name: "test.pdf")
    asset2 = Asset.create(name: "foo.pdf")
    selected = Asset.select((rec) ->
      rec.name is "foo.pdf"
    )
    expect(selected).toEqual [asset2]


  it "can return all records", ->
    asset1 = Asset.create(name: "test.pdf")
    asset2 = Asset.create(name: "foo.pdf")
    expect(Asset.all()).toEqual [asset1, asset2]

  it "can destroy all records", ->
    Asset.create name: "foo.pdf"
    Asset.create name: "foo.pdf"
    expect(Asset.count()).toEqual 2
    Asset.destroyAll()
    expect(Asset.count()).toEqual 0


  it "can be serialized into JSON", ->
    asset = new Asset(name: "Johnson me!")
    expect(JSON.stringify(asset.attributes())).toEqual "{\"name\":\"Johnson me!\"}"

  # it "can be deserialized from JSON", ->
  #   asset = Asset.fromJSON("{\"name\":\"Un-Johnson me!\"}")
  #   expect(asset.name).toEqual "Un-Johnson me!"
  #   assets = Asset.fromJSON("[{\"name\":\"Un-Johnson me!\"}]")
  #   expect(assets[0] and assets[0].name).toEqual "Un-Johnson me!"


  it "can validate", ->
    Asset.include validate: ->
      "Name required"  unless @name
    expect(Asset.create(name: "")).toBeFalsy()
    expect(Asset.create(name: "Yo big dog")).toBeTruthy()


  it "has attribute hash", ->
    asset = new Asset(name: "wazzzup!")
    expect(asset.attributes()).toEqual name: "wazzzup!"


  it "attributes() should not return undefined atts", ->
    asset = new Asset()
    expect(asset.attributes()).toEqual {}


  it "can load attributes()", ->
    asset = new Asset()
    result = asset.load(name: "In da' house")
    expect(result).toBe asset
    expect(asset.name).toEqual "In da' house"


  it "can load() attributes respecting getters/setters", ->
    Asset.include name: (value) ->
      ref = value.split(" ", 2)
      @first_name = ref[0]
      @last_name = ref[1]

    asset = new Asset()
    asset.load name: "Javi Jimenez"
    expect(asset.first_name).toEqual "Javi"
    expect(asset.last_name).toEqual "Jimenez"


  it "attributes() respecting getters/setters", ->
    Asset.include name: ->
      "Bob"

    asset = new Asset()
    expect(asset.attributes()).toEqual name: "Bob"


  it "can generate UID", ->
    asset = Asset.create name: "who's in the house?"
    expect(asset.uid).toBeTruthy()


  it "can be cloned", ->
    asset = Asset.create name: "what's cooler than cool?"
    expect(asset.clone().__proto__).not.toBe Asset::


  it "clones are dynamic", ->
    asset = Asset.create name: "hotel california"
    clone = Asset.find(asset.uid)
    asset.name = "checkout anytime"
    asset.save()
    expect(clone.name).toEqual "checkout anytime"


  it "create or save should return a clone", ->
    asset = Asset.create name: "what's cooler than cool?"
    expect(asset.__proto__).not.toBe Asset::
    expect(asset.__proto__.__proto__).toBe Asset::


  it "should be able to change ID", ->
    asset = Asset.create name: "hotel california"
    expect(asset.uid).toBeTruthy()
    asset.changeUID "foo"
    expect(asset.uid).toBe "foo"
    expect(Asset.exists("foo")).toBeTruthy()


  it "new records should not be eql", ->
    asset1 = new Asset
    asset2 = new Asset
    expect(asset1.equal(asset2)).not.toBeTruthy()


  it "should generate unique cIDs", ->
    Asset.create
      name: "Bob"
      id: 3

    Asset.create
      name: "Bob"
      id: 2

    expect(Asset.all()[0].equal(Asset.all()[1])).not.toBeTruthy()


  it "should handle more than 10 cIDs correctly", ->
    i = 0
    while i < 12
      Asset.create name: "Bob" ,id: i
      i++
    expect(Asset.count()).toEqual 12

  describe "with spy", ->
    spy = undefined
    beforeEach ->
      noop = spy: ->
      spyOn noop, "spy"
      spy = noop.spy


    it "can interate over records", ->
      asset1 = Asset.create name: "test.pdf"
      asset2 = Asset.create name: "foo.pdf"
      Asset.each spy
      expect(spy).toHaveBeenCalledWith asset1
      expect(spy).toHaveBeenCalledWith asset2

    # it "can fire create events", ->
    #   Asset.bind "create", spy
    #   asset = Asset.create name: "cartoon world.png"
    #   expect(spy).toHaveBeenCalledWith asset, {}

  #   it "can fire save events", ->
  #     Asset.bind "save", spy
  #     asset = Asset.create(name: "cartoon world.png")
  #     expect(spy).toHaveBeenCalledWith asset, {}
  #     asset.save()
  #     expect(spy).toHaveBeenCalled()

  #   it "can fire update events", ->
  #     Asset.bind "update", spy
  #     asset = Asset.create(name: "cartoon world.png")
  #     expect(spy).not.toHaveBeenCalledWith asset
  #     asset.save()
  #     expect(spy).toHaveBeenCalledWith asset, {}

  #   it "can fire destroy events", ->
  #     Asset.bind "destroy", spy
  #     asset = Asset.create(name: "cartoon world.png")
  #     asset.destroy()
  #     expect(spy).toHaveBeenCalledWith asset, {}

  #   it "can fire events on record", ->
  #     asset = Asset.create(name: "cartoon world.png")
  #     asset.bind "save", spy
  #     asset.save()
  #     expect(spy).toHaveBeenCalledWith asset, {}

  #   it "can fire change events on record", ->
  #     Asset.bind "change", spy
  #     asset = Asset.create(name: "cartoon world.png")
  #     expect(spy).toHaveBeenCalledWith asset, "create", {}
  #     asset.save()
  #     expect(spy).toHaveBeenCalledWith asset, "update", {}
  #     asset.destroy()
  #     expect(spy).toHaveBeenCalledWith asset, "destroy", {}

  #   it "can fire error events", ->
  #     Asset.bind "error", spy
  #     Asset.include validate: ->
  #       "Name required"  unless @name

  #     asset = new Asset(name: "")
  #     expect(asset.save()).toBeFalsy()
  #     expect(spy).toHaveBeenCalledWith asset, "Name required"

  #   it "should be able to bind once", ->
  #     Asset.one "save", spy
  #     asset = new Asset(name: "cartoon world.png")
  #     asset.save()
  #     expect(spy).toHaveBeenCalledWith asset, {}
  #     spy.reset()
  #     asset.save()
  #     expect(spy).not.toHaveBeenCalled()

  #   it "should be able to bind once on instance", ->
  #     asset = Asset.create(name: "cartoon world.png")
  #     asset.one "save", spy
  #     asset.save()
  #     expect(spy).toHaveBeenCalledWith asset, {}
  #     spy.reset()
  #     asset.save()
  #     expect(spy).not.toHaveBeenCalled()

  #   it "it should pass clones with events", ->
  #     Asset.bind "create", (asset) ->
  #       expect(asset.__proto__).not.toBe Asset::
  #       expect(asset.__proto__.__proto__).toBe Asset::

  #     Asset.bind "update", (asset) ->
  #       expect(asset.__proto__).not.toBe Asset::
  #       expect(asset.__proto__.__proto__).toBe Asset::

  #     asset = Asset.create(name: "cartoon world.png")
  #     asset.updateAttributes name: "lonely heart.png"

  #   it "should be able to unbind instance events", ->
  #     asset = Asset.create(name: "cartoon world.png")
  #     asset.bind "save", spy
  #     asset.unbind()
  #     asset.save()
  #     expect(spy).not.toHaveBeenCalled()

  #   it "should unbind events on instance destroy", ->
  #     asset = Asset.create(name: "cartoon world.png")
  #     asset.bind "save", spy
  #     asset.destroy()
  #     asset.trigger "save", asset
  #     expect(spy).not.toHaveBeenCalled()

  #   it "callbacks should still work on ID changes", ->
  #     asset = Asset.create(
  #       name: "hotel california"
  #       id: "bar"
  #     )
  #     asset.bind "test", spy
  #     asset.changeID "foo"
  #     asset = Asset.find("foo")
  #     asset.trigger "test", asset
  #     expect(spy).toHaveBeenCalled()


