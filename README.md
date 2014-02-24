cargoship-logstash
==================

    ship.use (require 'cargoship-logstash') port or ()
    
You should pass Logstash tcp address via port or process.env.LOGSTASH_REDIS_PORT, which should be in form of "tcp://host:port".

Cargoship tells logstash via redis input. 

```
input {
  redis {
    host => "172.17.42.1"
    data_type => "list"
    key => "logstash"
    codec => json
  }
}
```

