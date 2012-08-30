class Monocle.Model extends Monocle.Module

    @extend Monocle.Events
    @records    : {}
    @attributes : []
    @uid_counter: 0

    # @configure: (@className, attributes...) ->
    @configure: (name, attributes...) ->
        @className  = name
        @records    = {}
        @attributes = attributes if attributes.length
        @attributes or =  []
        @unbind()
        @

    # Class Methods
    @create: (attributes) ->
        record = new @(attributes)
        record.save()

    @uid: (prefix = 'c-') ->
        uid = prefix + @uid_counter++
        uid = guid()
        #uid = @uid(prefix) if @exists(uid)
        uid

    @exists: (uid) ->
        try
            return @find(uid)
        catch e
            return false

    @find: (uid) ->
        record = @records[uid]
        throw new Error('Unknown record') unless record
        record.clone()

    @findBy: (name, value) ->
        for id, record of @records
            if record[name] is value
                return record.clone()
        throw new Error('Unknown record')

    #WTF: ??
    @select: (callback) ->
        result = (record for id, record of @records when callback(record))
        @cloneArray(result)

    @all: -> @cloneArray(@recordsValues())

    @count: -> @recordsValues().length

    @cloneArray: (array) -> (value.clone() for value in array)

    @recordsValues: ->
        result = []
        for key, value of @records
            result.push(value)
        result

    @destroyAll: -> @records = {}

    # Instance Methods
    constructor: (attributes) ->
        super
        @load attributes if attributes
        @uid = @constructor.uid()

    isNew: -> not @exists()

    exists: -> @uid && @uid of @constructor.records

    clone: -> createObject(this)

    load: (attributes) ->
        for key, value of attributes
            if typeof @[key] is 'function'
                @[key](value)
            else
            @[key] = value
        this

    attributes: ->
        result = {}
        for key in @constructor.attributes when key of this
            if typeof @[key] is 'function'
                result[key] = @[key]()
            else
                result[key] = @[key]
        result.id = @id if @id
        result

    save: () ->
        error = @validate()
        if error
            @trigger('error', error)
            return false

        @trigger('beforeSave')
        record = if @isNew() then @create() else @update()
        @trigger('save')
        record

    updateAttributes: (attributes, options) ->
        @load(attributes)
        @save()

    create: ->
        @trigger('beforeCreate')

        record = new @constructor(@attributes())
        record.uid = @uid
        @constructor.records[@uid] = record

        @trigger('create')
        @trigger('change', 'create')
        record.clone()

    update: ->
        @trigger('beforeUpdate')

        records = @constructor.records
        records[@uid].load @attributes()

        @trigger('update')
        @trigger('change', 'update')
        records[@uid].clone()

    destroy: ->
        @trigger('beforeDestroy')
        delete @constructor.records[@uid]
        @trigger('destroy')
        @trigger('change', 'destroy')
        @unbind()
        @

    validate: -> throw new Error("#{error} in #{@constructor.name} model")

    clone: -> Object.create(@)

    unbind: -> @trigger('unbind')

    trigger: (args...) ->
        args.splice(1, 0, @)
        @constructor.trigger(args...)

# Utilities & Shims
unless typeof Object.create is 'function'
    Object.create = (o) ->
        Func = ->
        Func.prototype = o
        new Func()

guid = ->
    'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace /[xy]/g, (c) ->
        r = Math.random() * 16 | 0
        v = if c is 'x' then r else r & 3 | 8
        v.toString 16
    .toUpperCase()
