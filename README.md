Monocle
=======
Built to work with the most famous libraries of the web development. If your project is desktop you can use it with jQuery and if on the contrary it is a mobile project it will perfectly mixed with QuoJS or Zepto.

Monocle uses the MVC pattern and work seamlessly with CoffeeScript. All your applications will be pure verbosity and poetry. If you also want to use me in old-school mode with the all powerful of JavaScript.

*Current version: [1.0.2]()*

Getting Started
---------------
Monocle gives you a simple and powerful structure to make the most of your web applications. An application consists of three work contexts: Model, View and Controller, developers usually call it the MVC pattern. These three contexts are equally important and each has its full integrity giving responsibility to your application.

### GitHub
This is opensource, so feel free to fork this project to help us improve Monocle MVC framework. All source code is developed with CoffeeScript.

### Licensing
Monocle is licensed under GPLv3 licensed and a Commercial License for OEM uses. See [LICENSE](https://github.com/soyjavi/monocle/blob/master/LICENSE) for more information.

How to use
----------
### Model:
Usually we find others MVC where the model becomes complex and heavy. With monocle wont have that feeling, the model does exactly what you need without becoming complex conventions, simple but powerfull, let's see how to create one:


	class Task extends Monocle.Model
    	@fields "name", "description", "type", "done"


If you are interested you can create extra attributes to give more value and integrity to our model:


	class Task extends Monocle.Model
    	@fields "name", "description", "type", "done"

    	# Extra attributes
    	@mixAttributes: ->
        	"#{name} - #{description}"

    	@done: ->
        	@select (task) -> !!task.done

A very interesting feature of the models is data validation rules, for it only have to create a method called "validate" and include your exceptions. Let's see how to create one:


	class Task extends Monocle.Model
    	# ...
    	validate: ->
        	unless @name
            	"name is required"

Your model has many methods to help you better manage the derived instances. Also note that each new instance of a model is stored in the internal repository record (we will learn to use later):


	task = new Task()
	task.name = "Clean my teeth"
	task.type = "Home"
	task.save()

	# Or you can try:
	task = new Task name: "Go to the meeting", type: "Work"
	task.save()

	# Inline way
	Task.create name: "Learn CoffeeScript", type: "Personal"

If you want to know all instances of a given model just use the method "all":


	for task in Task.all()
    	console.log task.name


To find instances in the internal repository record, you can use several methods that will be very useful. Also say that all instances have an internal attribute as a UID to identify each of them:


	task = Task.find(uid)
	# If you want search for a particular attribute
	task = Task.findBy "name", "Dexter"

	# You can select a group of instances based on a rule
	undone_tasks = Task.select(task) -> !task.done


You can update any attribute in a very simple way:


	task.name = "Go to the evening meeting"
	task.save()

	# Inline way
	task.updateAttributes name: "Go to the evening meeting"


If you want to know the attributes of a particular instance:


	task.attributes()

And of course, you can delete an instance:


	task.destroy()


### View: 

A major problem that exists with the views in Web Applications is the choice of a template engine. Monocle puts you it very easy with Mustache one of the most used template engines of the planet. It also facilitated communication between the model and the view. Let's see how to instantiate a new view:


	class TaskItem extends Monocle.View

    	container: "ul#tasks"

    	template_url: "templates/task.mustache"

If you prefer, you can define your mustache template directly in the view:


	class TaskItem extends Monocle.View
    	template:
        	"""
        	<li>
            	<strong>{{name}}</strong>
            	<small>{{description}}</small>
        	</li>
        	"""
Monocle facilitates you the communication between the model and the view, for example in the following code you see how to capture an event in our view (click on the item li) and show exactly the data of model it contains:


	class TaskItem extends Monocle.View
    	# ...
    	events:
        	"click li": "onClick"

    	onClick: (event) ->
        	console.error "Current Item", @model

An interesting feature is the control of a subelement in a view. The following example shows the creation of a strong element of our template and you can use it in the whole context of the view with the shortcut @name:


	class TaskItem extends Monocle.View
   		
    	elements:
        	"strong": "name"

    	exampleMethod: -> @name.html "new content"

To render a view we have several methods to use depending on your needs:


	view = new TaskItem model: data
	# Append to container
	view.append task
	# Prepend
	view.prepend task
	# html
	view.html task
	# Remove current view (and model reference)
	view.remove()
	# Refresh a template
	view.refresh()

### Controller:
Instantiate a controller is something different from the model and the view, so we must tell our DOM element that we want to control:

	class Tasks extends Monocle.Controller

	controller = new Tasks "section#tasks"

In this way, you could have multiple controllers with the same business code but managing different areas of your application:

	controller_section = new Tasks "section#tasks"
	controller_aside = new Tasks "aside#tasks"

A controller shares much functionality with the view (although you should not confuse), for example you can both capture events as subelements:


	class Tasks extends Monocle.Controller
    	# ...
    	constructor: ->
        	super
        	Task.bind "create", @bindTaskCreate
        	Task.bind "delete", @bindTaskDelete

    	bindTaskCreate: (task) ->
        	alert "You've created #{task.name}!"

    	bindTaskDelete: (task) ->
        	alert "You've deleted #{task.name}!"


#### Routing: go anywhere you want
The routing system in Monocle is very clean, and does not detract versatility. For this we only have to extend the controller with the routes you want to manage. It's simple, just have to indicate which routes we'll want to capture and Monocle controller will do the rest:


	class Tasks extends Monocle.Controller
    	constructor: ->
        	super
        	@routes
            	"/tasks"    : @listTasks
        	Monocle.Route.listen()

    	listTasks: -> console.log "List all tasks"


	controller = new Tasks "section#tasks"


You can control all the routes who needs your controller and even capture the parameters you want:


	class Tasks extends Monocle.Controller
    	constructor: ->
        	super
        	@routes
            	"/task/:id" : @viewTask
        	Monocle.Route.listen()

    	viewTask: (params) ->
        	console.log "You choose task with id: #{params.id}"

	controller = new Tasks "section#tasks"


Everything isn't capturing routes can also assign a new URL path in your application from any context:


	id = 1980
	@url "task", id #goes to http://*#/task/1980













