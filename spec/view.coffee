describe "View", ->
  task      = undefined
  TaskView  = undefined
  container = "ul.tasks"
  template  = "<li>{{name}}</li>"
  template_url = "spec/dependencies/template.mustache"
  element = undefined

  beforeEach ->
    class Task extends Monocle.Model
      @fields: "title", "description"
    task = new Task name: "Sample of task", description: "Lorem"

    class TaskView extends Monocle.View
      @container  : container
      @template   : template

    element = Monocle.Dom "<div/>"
    element.addClass("tasks")


  it "can set container", ->
    expect(TaskView.container).toEqual container


  it "can set a DOM container", ->
    taskview = new TaskView container: element
    expect(taskview.container).toEqual element


  it "can set inline template", ->
    expect(TaskView.template).toEqual template


  it "can set a template url", ->
    taskview = new TaskView template_url: template_url
    # expect(TaskView.template).toEqual template


  it "can create a instance with a model reference", ->
    taskview = new TaskView model: task
    expect(taskview.model).toEqual task


  it "can render a model", ->
    taskview = new TaskView model: task, container: element
    taskview.html task
    expect(taskview.el.html()).toEqual task.name


  it "can append view to a container", ->
    taskview = new TaskView model: task, container: element
    taskview.append task
    expect(element.children().length).toEqual 1

    taskview = new TaskView model: task, container: element
    taskview.append name: "s"
    expect(element.children().length).toEqual 2

    expect(element.children()[1]).toEqual taskview.el[0]


  it "can prepend view to a container", ->
    taskview = new TaskView model: task, container: element
    taskview.prepend task
    expect(element.children().length).toEqual 1

    taskview = new TaskView model: task, container: element
    taskview.prepend name: "s"
    expect(element.children().length).toEqual 2

    expect(element.children()[0]).toEqual taskview.el[0]


  it "can update view with a model", ->
    taskview = new TaskView model: task, container: element
    taskview.append task

    task.name = "Updated task"
    taskview.refresh()
    expect(element.children('li').html()).toEqual = "Updated task"

  it "can remove", ->
    taskview = new TaskView model: task, container: element
    taskview.append task
    expect(element.children().length).toEqual 1

    taskview.destroy()
    expect(element.children().length).toEqual 0


