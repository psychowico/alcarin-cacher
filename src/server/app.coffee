'use strict'

###
This server listening for connection from php app. For any connection it
generate AppClient object. It used 'net' for communication (tcp protocol, sending json)
###

net       = require 'net'
AppClient = require '../app-client'
config    = require '../config'
EventsBus = require '../events-bus'
Q         = require 'q'
log       = require '../logger'

class AppProxy

    clients : []

    start: =>
        deferred = Q.defer()

        server = net.createServer().listen config.app_port, '127.0.0.1', ->
            deferred.resolve server
            log.info "-- App server ready, listening on #{config.app_port}"
        server.on 'connection', @onAppConnected
        server.on 'error', (err)->
            deferred.reject err
            log.error  "Port #{config.app_port} is in use. Can not continue." if err.code == 'EADDRINUSE'
        EventsBus.on 'app-client.disconnected', @onAppDisconnected

        deferred.promise

    onAppConnected: (socket)=>
        @clients.push new AppClient @, socket

    onAppDisconnected: (client)=>
        ind = @clients.indexOf client.socket
        @clients.splice ind, 1

module.exports = new AppProxy()