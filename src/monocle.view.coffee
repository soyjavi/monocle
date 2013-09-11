"use strict"

class Monocle.View extends Monocle.Controller

    @container: undefined
    @template_uri: undefined
    @template: undefined
    @model: undefined

    constructor: (options) ->
        super
        @template = @constructor.template unless @template
        @_loadTemplateFrom(@template_url) unless @template

        @container = @constructor.container unless @container
        @container = Monocle.Dom @container
        @container.attr 'data-monocle', @constructor.name

    html: (elements...) -> @_html "html", elements...

    append: (elements...) -> @_html "append", elements...

    prepend: (elements...) -> @_html "prepend", elements...

    remove: () ->
        #@TODO: Esto porqué?? es mejor que no elimine automáticamente el modelo no?
        # @model.destroy()
        @el.remove()

    replace: (element) ->
        [previous, @el] = [@el, Monocle.Dom(element.el or element)]
        previous.replaceWith @el
        @delegateEvents(@events)
        @refreshElements()
        @el

    refresh: ->
        render = Monocle.templayed(@template)(@model)
        @replace render

    _html: (method, elements...) ->
        elements = (element.el or element for element in elements)
        render = Monocle.templayed(@template)(elements...)
        @replace(render)
        @container[method] @el
        @

    _loadTemplateFrom: (url) ->
        unless Monocle.Templates[@className]
            loader = if $$? then $$ else $
            response = loader.ajax
                            url: url
                            async: false
                            dataType: 'text'
                            error: -> console.error arguments
            response = response.responseText unless $$?
            Monocle.Templates[@className] = response

        @template = Monocle.Templates[@className]
