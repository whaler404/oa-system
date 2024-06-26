import 'dart:convert';

import 'package:dart_amqp/dart_amqp.dart' as amqp;
import 'package:fixflow/config/notificationService.dart';
import 'package:fixflow/config/user_token_provider.dart';

// Service class for handling AMQP (Advanced Message Queuing Protocol) communication.
class AMQPService {
  final NotificationService notificationService;
  final UserTokenProvider userTokenProvider;
  amqp.Client? _client;
  amqp.Consumer? _consumer;
  bool _isListening = false;

  AMQPService(this.notificationService, this.userTokenProvider);

  // Starts listening for incoming messages from the AMQP server.
  void startListening() {
    if (_isListening) {
      print("AMQP consumer is already running");
      return;
    }

    final username = userTokenProvider.username;
    final password = userTokenProvider.password;

    if (username == null || password == null) {
      print("Username or password is null");
      return;
    }

    print("Attempting AMQP connection with username: $username and password: $password");

    _client = amqp.Client(
      settings: amqp.ConnectionSettings(
        host: "139.199.168.63",
        port: 5672,
        authProvider: amqp.PlainAuthenticator("user", "user"),
      ),
    );

    _client!.channel().then((amqp.Channel channel) {
      print("AMQP channel successfully opened");
      return channel.queue("rabbitmq.topic.$username", durable: true);
    }).then((amqp.Queue queue) {
      print("Queue ${queue.name} declared");
      print(" [*] Waiting for messages in ${queue.name}. To exit press CTRL+C");

      return queue.consume().then((amqp.Consumer consumer) {
        _consumer = consumer;
        _isListening = true;
        print("Consumer successfully started");
        consumer.listen((amqp.AmqpMessage message) {
          print(" [x] Received ${message.payloadAsString}");

          try {
            var decodedPayload = jsonDecode(message.payloadAsString);
            String msgName = decodedPayload['msgName'];
            String msgContent = decodedPayload['msgContent'];
            notificationService.showNotification(msgName, msgContent);
          } catch (e) {
            print("Error parsing message payload: $e");
          }
        }).onDone(() {
          _isListening = false;
          print("Consumer has stopped");
        });
      });
    }).catchError((error) {
      _isListening = false;
      print("Error in AMQP connection: $error");
    });
  }

  // Stops listening for messages and closes the AMQP connection.
  void stopListening() {
    _consumer?.cancel().then((_) {
      _isListening = false;
      _client?.close();
      _client = null;
      _consumer = null;
      print("AMQP connection closed and consumer cancelled");
    }).catchError((error) {
      _isListening = false;
      print("Error closing AMQP connection: $error");
    });
  }
}
