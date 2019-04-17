## q_it

q_it is a simple console based application that uses the AWS SQS service to publish and subscribe to messages.

##### How to use Q_IT? 

Publishing messages with Q_IT

```
> ruby app.rb publish <your-queue-name(required)> <sleep_time_seconds(optional)>

```


Subscribing to messages with Q_IT

```
> ruby app.rb subscribe <your-queue-url(required)> <sleep_time_seconds(optional)>

```


**sleep_time_seconds** - is the time in seconds between two consequtive send_message / receive_message calls made to the sqs server.


While publishing to /subscribing from a queue it defaults to 5 seconds. 

Acceptable values while **publishing** for sleep_time_seconds : Between 5-20 seconds.

Acceptable values while **subscribing** for sleep_time_seconds : Between 3-15 seconds.
