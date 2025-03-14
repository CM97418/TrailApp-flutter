import 'package:geolocator/geolocator.dart';

class GpsService {
  Future<Position> getPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Vérifier que les services de localisation sont activés
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Les services de localisation sont désactivés.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Les permissions de localisation sont refusées');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Les permissions sont définitivement refusées.');
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }
}
