import 'dart:async';
import 'dart:math';
import 'package:sensors_plus/sensors_plus.dart';

class AccelerometerService {
  StreamSubscription? _subscription;
  Function(double)? onData;

  void startListening(Function(double) callback) {
    onData = callback;
    _subscription = accelerometerEvents.listen((event) {
      double magnitude = sqrt(event.x * event.x + event.y * event.y + event.z * event.z);
      onData?.call(magnitude);
    });
  }

  void stopListening() {
    _subscription?.cancel();
  }
}
