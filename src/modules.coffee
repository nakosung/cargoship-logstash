_ = require 'underscore'

attached = undefined

module.exports = (port) ->
	modules = (m,next) -> next m
	modules.signature = 'logstash'

	modules.preuse = (ship) ->
		logstash = port or process.env.LOGSTASH_PORT
		if logstash?
			winston = require 'winston'

			unless attached
				attached = logstash
				require 'winston-logstash'

				winston.add winston.transports.Logstash, (require 'docker-port-parser') logstash
			else if attached != logstash
				winston.error "inconsistent logstash", old:attached, cur:logstash

			ship.log = (ch,msg,meta) ->
				winston.log ch, msg, _.extend ship:ship.user, meta

	modules
