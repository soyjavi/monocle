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

  # it "can append view to a container", -> expect(false).toBeTruthy()

  # it "can prepend view to a container", -> expect(false).toBeTruthy()

  # it "can update view to a container", -> expect(false).toBeTruthy()
