Frontend JavaScript for nodePush
================================
Copyright Information
---------------------

	"@author	Tim Düsterhus"
	"@copyright	2012-2013 Tim Düsterhus"
	"@license	BSD 3-Clause License <http://opensource.org/licenses/BSD-3-Clause>"
	"@package	be.bastelstu.wcf.nodePush"

Setup
-----
Ensure sane values for `$` and `window`

	(($, window) ->
		# Enable strict mode
		"use strict";
		
		# Ensure our namespace is present
		window.be ?= {}
		be.bastelstu ?= {}
		be.bastelstu.wcf ?= {}

Overwrite `console` to add the origin in front of the message

		console =
			log: (message) ->
				window.console.log "[be.bastelstu.wcf.nodePush] #{message}"
			warn: (message) ->
				window.console.warn "[be.bastelstu.wcf.nodePush] #{message}"
			error: (message) ->
				window.console.error "[be.bastelstu.wcf.nodePush] #{message}"

be.bastelstu.wcf.nodePush
=========================

Private Attributes
------------------

		socket = null
		connected = false
		initialized = false
		events =
			connect: $.Callbacks()
			disconnect: $.Callbacks()
			message: { }
		
		be.bastelstu.wcf.nodePush = 

Methods
-------

**init(string host)**  
Initialize socket.io to enable nodePush.

			init: (host) ->
				return if initialized
				initialized = true
				console.log 'Initializing nodePush'
				
				unless window.io?
					console.error 'nodePush not available, aborting'
					return
					
				socket = window.io.connect host
				
				socket.on 'connect', ->
					console.log 'Connected to nodePush'
					socket.emit 'userID', WCF.User.userID
				
				socket.on 'authenticated', ->
					console.log 'Exchanged userID with nodePush'
					connected = true
					events.connect.fire()
				
				socket.on 'disconnect', ->
					connected = false
					console.warn 'Lost connection to nodePush'
					events.disconnect.fire()
				
				socket.on 'message', (message) ->
					return unless events.message[message]?
					
					events.message[message].fire()

**boolean onConnect(Function callback)**  
Adds a new `callback` that will be called when a connection to nodePush is established and the
userID was exchanged. The given `callback` will be called once if a connection is established at
time of calling. Returns `true` on success and `false` otherwise.

			onConnect: (callback) ->
				return false unless $.isFunction callback
				
				events.connect.add callback
				
				callback() if connected
				true

**boolean onDisconnect(Function callback)**  
Adds a new `callback` that will be called when the connection to nodePush is lost. Returns `true`
on success and `false` otherwise.

			onDisconnect: (callback) ->
				return false unless $.isFunction callback
				
				events.disconnect.add callback
				true

**boolean onMessage(string message, Function callback)**  
Adds a new `callback` that will be called when the specified `message` is received. Returns `true`
on success and `false` otherwise.

			onMessage: (message, callback) ->
				false unless $.isFunction callback
				false unless /^[a-zA-Z0-9-_]+\.[a-zA-Z0-9-_]+(\.[a-zA-Z0-9-_]+)+$/.test message
				
				events.message[message] ?= $.Callbacks()
				events.message[message].add callback
				true
			
	)(jQuery, @)
