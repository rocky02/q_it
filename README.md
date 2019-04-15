## q_it

q_it is a simple console based application that uses the AWS SQS service to publish and subscribe to messages.

##### How to use Q_IT? 

Publishing messages with Q_IT

```
> ruby app.rb <your-queue-name(required)> <delay_seconds(optional)>

```

Subscribing to messages with Q_IT

```
> ruby subscriber.rb <your-queue-url(required)> <wait-time-seconds(optional)>

```
