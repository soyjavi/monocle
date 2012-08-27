class Task extends Monocle.Model
    @configure  "Tarea",
                "name", "done"

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

class TaskVw extends Monocle.View
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

class TaskCtrl extends Monocle.Controller
    events:
        "click  form a":   "onCreate"
        "click .clear": "onClear"

    elements:
        # ".clear":     "clear"
        "form input": "input"
        ".countVal":  "count"

    constructor: ->
        super
        Task.bind("create", @bindCreate)
        Task.bind("change", @bindChange)
        Task.bind("destroy", @bindDestroy)
        Task.bind("error", @bindError)

    bindError: (task) =>
        console.error arguments

    bindDestroy: (task) =>
        console.error "controller task destroy", task, arguments
        alert task.name

    bindCreate: (task) =>
        view = new TaskVw(item: task)
        #view.add(task)
        view.append(task)

    bindChange: =>
        active = Task.active().length
        @count.text(active)

    onCreate: (event) ->
        event.preventDefault()
        Task.create(name: @input.val())
        @input.val("")
        console.error "tasks >> ", Task.all()

    onClear: (event) ->
        event.preventDefault()
        Task.destroyDone()

app = new TaskCtrl(el: $$("#tasks"))



# =============================================================================

Task.create(name: "Cafe con Ina en el Laia")
# Task.create(name: "Charla Ibermatica")
# Task.create(name: "Volver a la oficina")

# console.error Task.all()

console.error "=================================================================="
