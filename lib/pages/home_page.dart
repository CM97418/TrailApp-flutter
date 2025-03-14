import 'package:flutter/material.dart';
import 'package:trail_app/services/gps_service.dart';
import 'package:trail_app/services/mqtt_service.dart';
import 'package:trail_app/services/accelerometer_service.dart';
import 'package:trail_app/services/battery_service.dart';
import 'package:trail_app/services/flash_service.dart';
import 'package:trail_app/services/speaker_service.dart';

class HomePage extends StatefulWidget {
  final String courseNumber;
  final String bibNumber;

  HomePage({required this.courseNumber, required this.bibNumber});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final gpsService = GpsService();
  final mqttService = MqttService();
  final accelerometerService = AccelerometerService();
  final batteryService = BatteryService();
  final flashService = FlashService();
  final speakerService = SpeakerService();

  String gpsData = "En attente...";
  String accelerometerData = "En attente...";
  String batteryLevel = "En attente...";

  @override
  void initState() {
    super.initState();

    // Connexion au broker MQTT
    mqttService.connect();

    // Récupération et envoi de la position GPS
    gpsService.getPosition().then((position) {
      setState(() {
        gpsData = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
      });
      mqttService.publish('trail/gps', '${position.latitude},${position.longitude}');
    });

    // Démarrage de l'écoute de l'accéléromètre
    accelerometerService.startListening((magnitude) {
      setState(() {
        accelerometerData = magnitude.toStringAsFixed(2);
      });
      mqttService.publish('trail/accelerometer', magnitude.toString());

      // Détection d'un incident (exemple : seuil de 15)
      if (magnitude > 15) {
        flashService.flash();
        speakerService.playAlert();
        mqttService.publish('trail/incident', 'Incident détecté: accélération élevée');
      }
    });

    // Récupération du niveau de batterie
    batteryService.getBatteryLevel().then((level) {
      setState(() {
        batteryLevel = '$level%';
      });
      mqttService.publish('trail/battery', '$level');
    });
  }

  @override
  void dispose() {
    accelerometerService.stopListening();
    mqttService.disconnect();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Trail App - Course ${widget.courseNumber}'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              Text('Dossard: ${widget.bibNumber}'),
              SizedBox(height: 20),
              Text('Position GPS: $gpsData'),
              SizedBox(height: 20),
              Text('Accéléromètre: $accelerometerData'),
              SizedBox(height: 20),
              Text('Niveau de batterie: $batteryLevel'),
            ],
          ),
        ));
  }
}
