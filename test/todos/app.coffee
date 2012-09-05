class __Model.Task extends Monocle.Model
    @configure  "name", "done"

    @active: ->
        @select (item) -> !item.done

    @done: ->
        @select (item) -> !!item.done

    @destroyDone: ->
        instance.destroy() for instance in @done()
        console.error Task.all()

    validate: ->
        unless @name
            "name is required"

class __View.Task extends Monocle.View
    container: ".items"

    template: """
        <div class="item {{#done}}done{{/done}}">
            <div class="view" title="Double click to edit...">
                <input type="checkbox" {{#done}}checked="checked"{{/done}}>
                <span>{{name}}</span> <a class="destroy"></a>
            </div>
            <div class="edit">
                <input type="text" value="{{name}}">
            </div>
        </div>"""

    events:
        "dblclick       .view" : "onEdit"
        "click          .destroy" : "onDestroy"
        "click          input[type=checkbox]": "onCheck"
        "blur           input[type=text]": "onBlur"

    elements:
        # "input[type=text]": "input"
        # ".countVal": "count"
        "input[type=checkbox]": "checkbox"

    onEdit: (data) ->
        # console.error "onEdit", @el, @item
        @el.addClass("editing")
        @input.focus()

    onBlur: (event) ->
        event.preventDefault()
        @el.removeClass("editing")
        @item.updateAttributes({name: @input.val()})
        @refresh()

    onCheck: (event) ->
        event.preventDefault()
        console.error "onCheck: ", arguments, @el, $('input[type=checkbox]').attr('checked')
        done = @checkbox.attr('checked')
        # done = "checked"
        console.error "onCheck -> ", done
        @item.updateAttributes(done: done)
        @refresh()

    onDestroy: -> @remove()

class __Controller.Task extends Monocle.Controller
    events:
        "click  form a":   "onCreate"
        "click .clear": "onClear"

    elements:
        # ".clear":     "clear"
        "form input": "input"
        ".countVal":  "count"

    constructor: ->
        super
        __Model.Task.bind("create", @bindCreate)
        __Model.Task.bind("change", @bindChange)
        __Model.Task.bind("destroy", @bindDestroy)
        __Model.Task.bind("error", @bindError)

    bindError: (task) =>
        console.error arguments

    bindDestroy: (task) =>
        console.error "controller task destroy", task, arguments
        alert task.name

    bindCreate: (task) =>
        # view = new __View.Task(item: task)
        view = new __View.Task(item: task)
        #view.add(task)
        tasks = []
        tasks.push task
        tasks.push task
        view.append(task)

    bindChange: =>
        active = __Model.Task.active().length
        @count.text(active)

    onCreate: (event) ->
        event.preventDefault()
        __Model.Task.create(name: @input.val())
        @input.val("")
        console.error "tasks >> ", __Model.Task.all()

    onClear: (event) ->
        event.preventDefault()
        __Model.Task.destroyDone()

# app = new __Controller.Task(el: $$("#tasks"))
app = new __Controller.Task('#tasks')


# =============================================================================

__Model.Task.create(name: "Cafe con Ina en el Laia")
__Model.Task.create(name: "Charla Ibermatica")
__Model.Task.create(name: "Volver a la oficina")
console.error __Model.Task.all()

console.error "=================================================================="
