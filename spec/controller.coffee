describe "Controller", ->
  Tasks = undefined
  element = undefined

  beforeEach ->
    class Tasks extends Monocle.Controller
    element = Monocle.Dom "<div />"

  it "set DOMElement to manage", ->
    tasks = new Tasks el: element


  it "set DOM Query to manage", ->
    tasks = new Tasks element.selector


  it "should be configurable", ->
    element.addClass "big"
    tasks = new Tasks el: element
    expect(tasks.el.hasClass("big")).toBeTruthy()

    tasks = new Tasks item: "foo"
    expect(tasks.item).toEqual "foo"


  it "should generate element", ->
    tasks = new Tasks()
    expect(tasks.el).toBeTruthy()


  it "can populate elements", ->
    Tasks.include elements:
      ".footer": "footer"

    element.append Monocle.Dom("<div />").addClass("footer")[0]
    tasks = new Tasks el: element
    expect(tasks.footer).toBeTruthy()
    expect(tasks.footer.hasClass("footer")).toBeTruthy()


  it "get handler of a child element", ->
    input = Monocle.Dom "<input type='text' id='name' />"
    element.html input[0]
    elements = "input#name": "name"
    tasks = new Tasks el: element, elements: elements

    expect(input[0]).toEqual tasks.name[0]


  it "can remove element upon release event", ->
    parent = Monocle.Dom "<div />"
    parent.append element[0]
    tasks = new Tasks(el: element)

    expect(parent.children().length).toBe 1
    tasks.destroy()
    expect(parent.children().length).toBe 0


  describe "with spy", ->
    spy = undefined
    beforeEach ->
      noop = spy: ->
      spyOn noop, "spy"
      spy = noop.spy

    it "can add events", ->
      Tasks.include
        events:
          click: "wasClicked"

        wasClicked: $.proxy spy, jasmine

      tasks = new Tasks el: element
      element.click()
      expect(spy).toHaveBeenCalled()

    it "can delegate events", ->
      Tasks.include
        events:
          "click .foo": "wasClicked"

        wasClicked: $.proxy(spy, jasmine)

      child = $("<div />").addClass("foo")
      element.append child
      tasks = new Tasks el: element
      child.click()
      expect(spy).toHaveBeenCalled()
