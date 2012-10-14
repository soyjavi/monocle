class __Model.Task extends Monocle.Model
    @fields  "name", "done"

    @active: ->
        @select (item) -> !item.done

    # @done: ->
    #     @select (item) -> !!item.done

    @destroyDone: ->
        instance.destroy() for instance in @done()

    validate: ->
        unless @name
            "name is required"

class __View.Task extends Monocle.View
    container: ".items"

    template_url: "templates/task.mustache"

    events:
        "dblclick       .view" : "onEdit"
        "click            .destroy" : "onDestroy"
        "click            input[type=checkbox]": "onCheck"
        "blur           input[type=text]": "onBlur"

    elements:
        "input[type=checkbox]": "checkbox"

    onEdit: (data) ->
        @el.addClass("editing")
        @input.focus()

    onBlur: (event) ->
        event.preventDefault()
        @el.removeClass("editing")
        @item.updateAttributes({name: @input.val()})
        @refresh()

    onCheck: (event) ->
        done = if @checkbox.attr('checked') is null then true else false
        @model.updateAttributes(done: done)
        @refresh()

    onDestroy: -> @remove()

class __Controller.Task extends Monocle.Controller
    events:
        "click  form a":   "onCreate"
        "click .clear": "onClear"

    elements:
        "form input": "input"
        ".countVal":  "count"

    constructor: ->
        super
        __Model.Task.bind("create", @bindCreate)
        __Model.Task.bind("change", @bindChange)
        __Model.Task.bind("destroy", @bindDestroy)
        __Model.Task.bind("error", @bindError)

    bindError: (task, error) -> alert error

    bindDestroy: (task) -> alert "#{task.name} deleted!"

    bindCreate: (task) =>
        view = new __View.Task(model: task)
        view.append task

    bindChange: =>
        active = __Model.Task.active().length
        @count.text active

    onCreate: (event) ->
        __Model.Task.create(name: @input.val())
        @input.val("")

    onClear: (event) -> __Model.Task.destroyDone()

app = new __Controller.Task('#tasks')

# =============================================================================

__Model.Task.create(name: "Cafe con Ina en el Laia")
__Model.Task.create(name: "Charla Ibermatica")
__Model.Task.create(name: "Volver a la oficina")
