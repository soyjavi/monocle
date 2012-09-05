class Monocle.Controller extends Monocle.Module

    @include Monocle.Events

    eventSplitter: /^(\S+)\s*(.*)$/
    tag: 'div'

    ###
    Constructor of Monocle.Controller based on Monocle.Module
    @method constructor
    @param  {options} Create properties within the controller or an element selector if the type is string.
    ###
    constructor: (options) ->
        if typeof options is "string"
            @el = Monocle.Dom(options)
        else
            @[key] = value for key, value of options

        @el = Monocle.Dom(document.createElement(@tag)) unless @el
        @events = @constructor.events unless @events
        @elements = @constructor.elements unless @elements

        @delegateEvents() if @events
        @refreshElements() if @elements
        super

    delegateEvents: ->
        for key, method of @events
            unless typeof(method) is 'function'
                method = @proxy(@[method])

            match      = key.match(@eventSplitter)
            eventName  = match[1]
            selector   = match[2]

            if selector is ''
                @el.bind(eventName, method)
            else
                @el.delegate(selector, eventName, method)

    refreshElements: ->
        for key, value of @elements
            # @[value] = @el.find(key)
            jq = $(key, @el)
            quo = @el.find(key)
            # if jq.length > 0
            #     console.error "refreshElements -> ", jq, quo
            @[value] = jq

    destroy: =>
        @trigger 'release'
        @el.remove()
        @unbind()
