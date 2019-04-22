## q_it

q_it is a simple console based application that uses the AWS SQS service to publish and subscribe to messages.

##### How to use Q_IT? 

Publishing messages with Q_IT

```
> ruby app.rb publish <your-queue-name(required)> <sleep_time_seconds(optional)>

```

* _Queue name_ - Should be between 3-80 characters long with any alphanumeric characters and hyphen(-) and underscore(_) are allowed.
* sleep_time_seconds : is the time in seconds between two consequtive send_message / receive_message calls made to the sqs server. Acceptable values range between 5-20 seconds.

Subscribing to messages with Q_IT

```
> ruby app.rb subscribe <your-queue-url(required)> <sleep_time_seconds(optional)>

```

* sleep_time_seconds : is the time in seconds between two consequtive send_message / receive_message calls made to the sqs server. Acceptable values range between 3-15 seconds.
