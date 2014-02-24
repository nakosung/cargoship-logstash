_ = require 'underscore'
redis = require 'redis'

module.exports = (port) ->
	modules = (m,next) -> next m
	modules.signature = 'logstash'

	modules.preuse = (ship) ->
		logstash = port or process.env.LOGSTASH_REDIS_PORT
		if logstash?
			{host,port} = (require 'docker-port-parser') logstash
			client = redis.createClient port, host

			old = ship.log.bind ship
			
			ship.log = (ch,msg,meta) ->
				json = 
					"@timestamp" : new Date().toISOString()
					"@message" : msg
					"@type" : ch
				_.extend json, meta

				client.rpush 'logstash', JSON.stringify json
				old ch,msg,meta

	modules
