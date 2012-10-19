describe "Controller", ->
  Tasks = undefined
  element = undefined

  beforeEach ->
    class Tasks extends Monocle.Controller
    element = $$ "<div />"

  it "set DOMElement to manage", ->
    tasks = new Tasks el: element

  it "set DOM Query to manage", ->
    tasks = new Tasks element.selector

  it "get handler of a child element", ->
    input = $$ "<input type='text' id='name' />"
    element.html input[0]
    elements = "input#name": "name"
    tasks = new Tasks el: element, elements: elements

    expect(input[0]).toEqual tasks.name[0]



