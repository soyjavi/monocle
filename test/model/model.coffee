class Task extends Monocle.Model
    @fields "name", "description", "type", "done"

    summary: ->  [@name, @done].join('-->')

    importe_mayor: ->
        @select (task) -> task.import > 100

    validate: ->
        unless @name
            "name is required"

# Create
task = new Task()
task.name = "Clean my teeth"
task.type = "Home"
task.save()
# Or you can try:
task = new Task name: "Go to the meeting", type: "Work", done: true
task.save()
# Inline way
Task.create name: "Learn CoffeeScript", type: "Personal"

console.error "-------------------- DATA --------------------"
tasks = Task.all()
console.log tasks
for task in tasks
    console.log task.name

console.error "-------------------- FIND --------------------"
console.log "Find: ", Task.find tasks[1].uid

# Si quieres buscar por un determinado field
console.log "FindBy: ", Task.findBy "name", "Clean my teeth"

# Tambien puedes seleccionar un grupo de instancias
console.log "Undone Tasks: ", Task.select (task) -> !task.done


console.error "------------------- UPDATE -------------------"
last_task = tasks[tasks.length - 1]
last_task.name = "Go to the evening meeting"
last_task.save()
# Inline way
last_task.updateAttributes name: "Go to the evening meeting with George"
console.log "Task updated: ", last_task.attributes()

console.error "------------------- DESTROY ------------------"
last_task.destroy()
console.log Task.all()
