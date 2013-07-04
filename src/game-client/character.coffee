'use strict'

###
Returning "Character" class. It has static factory methods that returning
Character object promise.
###

db = require '../tool/mongo'
Q  = require 'q'

class Character

    @fromId = (id)->
        deferred = Q.defer()
        # fetch character data and resolve character promise

        charpromise = Q.ninvoke db.collection('map.chars'), 'findOne', {'_id': db.ObjectId id}
        charpromise.then (result)->
            _char = new Character id
            _char[key] = prop for key, prop of result
            deferred.resolve _char
        charpromise.fail deferred.reject

        deferred.promise

module.exports = Character