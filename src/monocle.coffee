###
    Monocle 0.9.1
    http://monocle.tapquo.com

    Copyright (C) 2011,2012 Javi Jiménez Villar (@soyjavi)

    Permission is hereby granted, free of charge, to any person obtaining a
    copy of this software and associated documentation files (the "Software"),
    to deal in the Software without restriction, including without limitation
    the rights to use, copy, modify, merge, publish, distribute, sublicense,
    and/or sell copies of the Software, and to permit persons to whom the
    Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in
    all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
    FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
    DEALINGS IN THE SOFTWARE.
###

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
        throw('include(obj) requires obj') unless obj
        for key, value of obj when key not in moduleKeywords
            @::[key] = value

        included = obj.included
        included.apply(this) if included
        @

    @extend: (obj) ->
        throw('extend(obj) requires obj') unless obj
        for key, value of obj when key not in moduleKeywords
            @[key] = value

        extended = obj.extended
        extended.apply(this) if extended
        @

    @proxy: (method) ->
        => method.apply(@, arguments)

    proxy: (method) ->
        => method.apply(@, arguments)

    delay: (method, timeout) ->
        setTimeout(@proxy(method), timeout || 0)

    constructor: ->
        @init?(args...)

# Globals
Monocle = @Monocle = {}

Monocle.version     = "0.3"
Monocle.Events      = Events
Monocle.Module      = Module
Monocle.Dom         = (args...) -> if $$? then $$ args... else $ args...

# Global Shortcuts
@__ =  Monocle.App  = Model: {}, View: {}, Controller: {}
@__Model      = Monocle.App.Model
@__View       = Monocle.App.View
@__Controller = Monocle.App.Controller
