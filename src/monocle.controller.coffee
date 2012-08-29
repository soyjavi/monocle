class Monocle.Controller extends Monocle.Module

    @include Monocle.Events

    eventSplitter: /^(\S+)\s*(.*)$/
    tag: 'div'

    constructor: (options) ->
        @options = options

        for key, value of @options
            @[key] = value

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
