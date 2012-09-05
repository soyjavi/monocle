class Monocle.View extends Monocle.Controller

    @container: null

    constructor: (options) ->
        super
        @template = @constructor.template unless @template
        @container = @constructor.container unless @container
        @container = Monocle.Dom @container
        @container.attr 'data-monocle', @constructor.name

    html: (elements...) ->
        @_html "html", elements...

    append: (elements...) ->
        @_html "append", elements...

    prepend: (elements...) ->
        @_html "prepend", elements...

    remove: (elements...) ->
        @item.destroy()
        @el.remove()

    refresh: ->
        render = Mustache.render(@template, @item)
        @replace render

    _html: (method, elements...) ->
        elements = (element.el or element for element in elements)

        render = Mustache.render(@template, elements...)
        @replace(render)
        #@todo: QUOJS Bug >> Only one element
        @container[method] @el[0]
        @refreshElements()
        @

    replace: (element) ->
        #render = Mustache.render(@template, elements...)
        #@replace(render)

        [previous, @el] = [@el, Monocle.Dom(element.el or element)]
        #@todo: QUOJS Bug >> Only one element
        previous.replaceWith(@el[0])
        @delegateEvents(@events)
        @refreshElements()
        @el
