'use strict'

###
Starting GameClientServer and GameAppServer
###

log              = require './logger'
GameClientServer = require './server/browser'
GameAppServer    = require './server/app'
repl             = require './tool/repl-support'
gameloop         = require './gameloop'

client_server = new GameClientServer()
app_server = new GameAppServer()

client_server.start()
    .then(app_server.start)
    .then(gameloop.start)
    .done -> repl.setHook()