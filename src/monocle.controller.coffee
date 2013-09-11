"use strict"

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
    @className = @constructor.name
    if typeof options is "string"
      @el = Monocle.Dom options
    else
      @[key] = value for key, value of options

    @el = Monocle.Dom(document.createElement(@tag)) unless @el
    @events = @constructor.events unless @events
    @elements = @constructor.elements unless @elements

    do @delegateEvents if @events
    do @refreshElements if @elements
    super

  delegateEvents: ->
    for key, method of @events
      method = @proxy(@[method]) unless typeof(method) is 'function'

      match      = key.match(@eventSplitter)
      eventName  = match[1]
      selector   = match[2]

      if selector is ''
        @el.bind(eventName, method)
      else
        @el.delegate(selector, eventName, method)

  refreshElements: ->
     @[value] = @el.find(key) for key, value of @elements

  destroy: =>
      @trigger 'release'
      @el.remove()
      @unbind()
