Monocle
=======
Monocle esta creado para trabajar con las librerías mas utilizadas en el desarrollo web . Si tu proyecto web esta orientado a escritorio puedes combinarlo perfectamente con JQuery, en cambio si esta pensado para móviles puedes combinarlo con QuoJS o Zepto.

Monocle utiliza el patrón Modelo Vista Controlador. Con CoffeScript y Monocle harás que tu código parezca poesía. Aún  así también puedes utilizarlo a la vieja usanza con JavaScript

*Current version: [1.0.2]()*

Empieza a usarlo
---------------
Monocle te brinda una estructura simple y potente para realizar tus aplicaciones web. Una aplicación dispone de 3 contextos: Modelo,Vista y Controlador. Comunmente llamado patrón MVC. Estos 3 contextos son igual de importantes y con ellos manejaras la totalidad de tu aplicación.

### GitHub
Monocle es un proyecto opensource, así que sientete libre de hacer un fork del proyecto para ayudarnos a mejorar Monocle MVC. Todo el código fuente esta desarrollado en CoffeeScript

### Licencia
Monocle esta licenciado con GPLv3. Para mas información mirar : [LICENSE](https://github.com/soyjavi/monocle/blob/master/LICENSE).

Como utilizar Monocle
---------------------
### Modelo:
En otros MVC el modelo se convierte en algo pesado y difícil de utilizar. Con Monocle esta sensación desaparece, el modelo hace exactamente lo que necesitas sin agregarle complicadas convenciones, sencillo y potente, así se crea un modelo con Monocle:

	class Task extends Monocle.Model
    	@fields "name", "description", "type", "done"

Si te interesa puedes crear atributos extra al modelo para darle mas valor e integridad:


	class Task extends Monocle.Model
    @fields "name", "description", "type", "done"

    # Extra attributes
    @mixAttributes: ->
        "#{name} - #{description}"

    @done: ->
        @select (task) -> !!task.done

Una característica muy interesante de Monocle son las reglas para validar la integridad de nuestros modelos,para ello solo hay que crear un método "validate" e incluir tus excepciones. 

	class Task extends Monocle.Model
    	# ...
    	validate: ->
        	unless @name
            	"name is required"

Tu modelo tiene muchos métodos para ayudarte a manejar las instancias de este. A su vez recordar que cada nueva instancia de nuestro modelo se crea en el repositiorio de registros interno. Mas tarde aprenderemos como utilizarlo. Así se crea una instancia de un modelo en Monocle:

	task = new Task()
	task.name = "Clean my teeth"
	task.type = "Home"
	task.save()

	# O puedes utilizar:
	task = new Task name: "Go to the meeting", type: "Work"
	task.save()

	# En una sola línea...
	Task.create name: "Learn CoffeeScript", type: "Personal"

Si quieres recuperar todas las instancias de un modelo en concreto puedes utilizar el método "all":

	for task in Task.all()
    	console.log task.name

Existen varias maneras para encontrar instancias concretas dentro del repositorio de registros interno, cada instancia tiene un atributo interno llamado UID para identificarlas de manera unívoca, puedes utilizar cualquiera de estos métodos para obtenerlas. 

	task = Task.find(uid)
	# If you want search for a particular attribute
	task = Task.findBy "name", "Dexter"

	# You can select a group of instances based on a rule
	undone_tasks = Task.select(task) -> !task.done


Puedes actualizar el valor de cualquier atributo de la instancia de un modelo de manera sencilla:

	task.name = "Go to the evening meeting"
	task.save()

	# Inline way
	task.updateAttributes name: "Go to the evening meeting"

Si deseas conocer los atributos que tiene una instancia en particular:

	task.attributes()

Y por supuesto eliminar esa instancia:

	task.destroy()


### Vista 

Uno de los grandes problemas que existe con las vistas en as aplicaciones web es la elección del motor de plantillas.  Monocle te lo facilita con Mustache uno de los mas utilizados en todo el mundo. Además facilita la comunicación entre el modelo y la vista. Veamos como se instancia una nueva vista:

	class TaskItem extends Monocle.View

    	container: "ul#tasks"

    	template_url: "templates/task.mustache"

Si lo prefieres puedes definir tu plantilla de Mustache directamente en la vista:

	class TaskItem extends Monocle.View
    	template:
        	"""
        	<li>
            	<strong>{{name}}</strong>
            	<small>{{description}}</small>
        	</li>
        	"""

Monocle facilita comunicación entre vista y modelo por ejemplo a continuación vemos el código con el que capturar un evento dentro de nuestra vista(click en un elemento li) y seguido mostrar la información que contiene el correspondiente modelo.

	class TaskItem extends Monocle.View
    	# ...
    	events:
        	"click li": "onClick"

    	onClick: (event) ->
        	console.error "Current Item", @model

Una funcionalidad interesante es el control de un subelemento dentro de una vista. A continuación vemos como referenciar un elemento strong de nuestra plantilla para poder utilizarlo dentro del contexto de la vista dantole un nombre,en este caso @name:

	class TaskItem extends Monocle.View
   		
    	elements:
        	"strong": "name"

    	exampleMethod: -> @name.html "new content"

Para renderizar una vista tenemos varios métodos en función de tus necesidades:

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

#### Controlador
Para instanciar un controlador funciona de manera diferente a lo visto anteriormente con los modelos y las vistas, es necesarios decirle que elemento de nuestro DOM queremos controlar.

	class Tasks extends Monocle.Controller

	controller = new Tasks "section#tasks"

De esta manera puedes tener varios controladores con el mismo código de negocio pero manejando distintas areas de nuestra aplicación.

	controller_section = new Tasks "section#tasks"
	controller_aside = new Tasks "aside#tasks"

Un controlador comparte mucha de la funcionalidad con la vista, aun así no se debe confundir, por ejemplo ambas pueden capturar eventos de la misma manera que lo haciamos con los subelementos:


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


#### Enrutamiento
El sistema de enrutamiento de monocle es muy limpio y no desmerece en versatilidad. Para ello simplemente tenemos que extender el controlador con las rutas que queremos que maneje y el controlador se encargará del resto:


	class Tasks extends Monocle.Controller
    	constructor: ->
        	super
        	@routes
            	"/tasks"    : @listTasks
        	Monocle.Route.listen()

    	listTasks: -> console.log "List all tasks"


	controller = new Tasks "section#tasks"


Puedes controlar todas las rutas que necesite tu controlador e incluso capturar los parametros que necesites:

	class Tasks extends Monocle.Controller
    	constructor: ->
        	super
        	@routes
            	"/task/:id" : @viewTask
        	Monocle.Route.listen()

    	viewTask: (params) ->
        	console.log "You choose task with id: #{params.id}"

	controller = new Tasks "section#tasks"

Como no todo es capturar las rutas también podemos asignar un nuevo path URL a culquiera de los contextos de los que dispongamos

	id = 1980
	@url "task", id #goes to http://*#/task/1980













