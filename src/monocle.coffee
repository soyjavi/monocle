###
    Monocle 1.0.4
    http://monocle.tapquo.com
    Copyright (C) 2011,2013 Javi Jiménez Villar (@soyjavi)
###

"use strict"

Events =
    bind: (ev, callback) ->
        evs = ev.split(' ')
        calls = @hasOwnProperty('_callbacks') and @_callbacks or= {}

        for name in evs
            calls[name] or= []
            calls[name].push(callback)
        @

    trigger: (args...) ->
        ev = args.shift()

        list = @hasOwnProperty('_callbacks') and @_callbacks?[ev]
        return unless list

        for callback in list
            if callback.apply(@, args) is false
                break
        true

    unbind: (ev, callback) ->
        unless ev
            @_callbacks = {}
            return @

        list = @_callbacks?[ev]
        return @ unless list

        unless callback
            delete @_callbacks[ev]
            return @

        for cb, i in list when cb is callback
            list = list.slice()
            list.splice(i, 1)
            @_callbacks[ev] = list
            break
        @

moduleKeywords = ['included', 'extended']

class Module
    @include: (obj) ->
        throw new Error('include(obj) requires obj') unless obj
        for key, value of obj when key not in moduleKeywords
            @::[key] = value

        included = obj.included
        included.apply(this) if included
        @

    @extend: (obj) ->
        throw new Error('extend(obj) requires obj') unless obj
        for key, value of obj when key not in moduleKeywords
            @[key] = value

        obj.extended?.apply(this)
        @

    @proxy: (method) ->
        => method.apply(@, arguments)

    proxy: (method) ->
        => method.apply(@, arguments)

    delay: (method, timeout) ->
        setTimeout(@proxy(method), timeout || 0)

    constructor: ->
        @init?(arguments)

# Globals
Monocle = @Monocle = {}
Monocle.version     = "1.0.4"
Monocle.Events      = Events
Monocle.Module      = Module
Monocle.Templates   = {}
Monocle.Dom         = (args...) -> if $$? then $$ args... else $ args...

# Global events
Module.extend.call(Monocle, Events)

Module.create = (instances, statics) ->
  class Result extends this
  Result.include(instances) if instances
  Result.extend(statics) if statics
  Result.unbind?()
  Result

# Global Shortcuts
@__ =  Monocle.App = Model: {}, View: {}, Controller: {}
@__Model      = Monocle.App.Model
@__View       = Monocle.App.View
@__Controller = Monocle.App.Controller
