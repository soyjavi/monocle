
class Animal extends Monocle.Model
    @configure  "Animalillo",
                "key", "name", "type", "description"

    full: ->  [@name, @type].join('-->')

    validate: ->
        unless @description
            "description is required"


class AnimalVw extends Monocle.View
    container: '.animals ul'

    template: """
        <li id="{{uid}}">
            <strong>{{name}}</strong>
            <small>{{type}}</small>
            <a href="#">X</a>
        </li>"""

    events:
        "click li strong": "view"
        "click a": "destroy"

    elements:
        "li": "element"

    render: (data) ->
        a = [data, data]
        @append(data)

    view: (event) ->
        console.error "Hello #{@item.name}!"

    destroy: (event) ->
        console.error 'destroy', event, @item

# console.log "-------------------- CONTROLLER --------------------"

class AnimalCtrl extends Monocle.Controller

    events:
        "click      a.add": "add"
        "click      li strong": "viewItem"

    elements:
        "ul li": "items"
        "#txt-name": "name"
        "#txt-type": "type"

    constructor: ->
        super
        Animal.bind("create", @onCreate)
        Animal.bind("error", @onError)
        # @items.each ->
        #     console.error @

    onError: (model, error) ->
        console.error "Error: #{error}", model

    onCreate: (animal) ->
        view = new AnimalVw(item: animal)
        view.render(animal)

    add: (event) ->
        Animal.create({
            name: @name.val(),
            type: @type.val()
        })

        console.error(Animal.all())
        #console.error Animal.all()

    viewItem: (event) ->
        a = Animal.find("c-0")
        console.error "viewItem >> ", a, event

animal_ctrl = new AnimalCtrl(el: $('.animals'))


Animal.create({'name': 'Flipper', 'type':'dolphin'})
Animal.create({'name': 'Dexter', 'type':'cat', 'description': 'Persian'})

console.error Animal.all()
