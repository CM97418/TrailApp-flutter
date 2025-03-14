import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class MqttService {
  final String broker = 'broker.hivemq.com'; // ou votre broker
  final String clientId = 'trail_app_client';
  late MqttServerClient client;

  MqttService() {
    client = MqttServerClient(broker, clientId);
    client.logging(on: false);
  }

  Future<void> connect() async {
    try {
      await client.connect();
    } catch (e) {
      print('Erreur de connexion MQTT: $e');
      client.disconnect();
    }
  }

  void publish(String topic, String message) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(message);
    client.publishMessage(topic, MqttQos.atLeastOnce, builder.payload!);
  }

  void disconnect() {
    client.disconnect();
  }
}
