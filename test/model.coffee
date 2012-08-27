class Animal extends Monocle.Model
    @configure  "Animalillo",
                "key", "name", "type"
                
    full: ->  [@name, @type].join('-->')

    validate: ->
        unless @name
            "name is required"


console.log "-------------------- DATA --------------------"

Animal.create({name: 'lucas', type: 'dog'})
Animal.create({type: 'aslkskks'})
Animal.create({name: 'dexter', type: 'cat'})
Animal.create({name: 'calcetines', type: 'cat'})
Animal.create({name: 'nemo', type: 'fish'})

animal = new Animal({'name': 'flipper'})
animal.save()

animal_2 = new Animal()
animal_2.name = 'King Kong'
animal_2.save()

animal_3 = new Animal({'name': 'donkey'})
animal_3.save()
animal_3.type = 'video game'
a = animal_3.save()

console.log 'RECORDS: ', Animal.records

console.log "-------------------- FIND --------------------"

record = Animal.find(animal_2.uid)
console.log "FIND #{animal_2.uid}: ", record

record = Animal.find(122)
console.log "FIND 122   : ", record

record = Animal.findBy('type', 'cat')
console.log "FINDBY type = 'cat'   : ", record, record.name, record.full()

record = Animal.findBy('type', 'donkey')
console.log "FINDBY type = 'cat'   : ", record, record.name

console.log "-------------------- DESTROY --------------------"

record.destroy()

console.log "-------------------- NEXT --------------------"

animals = Animal.all()


console.log 'RECORDS: ', Animal.records



# dog = new Animal({type: 'dog'})
# dog.create({id:2, name:'Perla'})

# fish = new Animal {id:4, name:'Nemo'}
# fish.name = "nemo"
# fish.save()

# cat = new Animal
# cat.create({id:3, name:'Dexter'})

#console.log Animal.attributes, dog, Animal.records

#console.log "attributes", dog.attributes(), fish.attributes()
