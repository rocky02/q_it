## q_it

q_it is a simple console based application that uses the AWS SQS service to publish and subscribe to messages.


To start the service use - 

```
> bin/q_it_server <service-name> <url/name> <sleep_period>
```

##### How to use Q_IT? 

Publishing messages with Q_IT

```
> bin/q_it_server publish <url/name> <sleep_period>

```

* _Queue name_ - Should be between 3-80 characters long with any alphanumeric characters and hyphen(-) and underscore(_) are allowed. Additionally, queue names are case-sensitive. That is queue name _QIt-test_ is different from queue name _Qit-test_.


* _sleep_time_seconds_ : is the time in seconds between two consecutive send_message / receive_message calls made to the sqs server. Acceptable values range between 5-20 seconds. 


Subscribing to messages with Q_IT

```
> bin/q_it_server subscribe <url/name> <sleep_period>

```

* _sleep_time_seconds_ : is the time in seconds between two consecutive send_message / receive_message calls made to the sqs server. Acceptable values range between 3-15 seconds.
