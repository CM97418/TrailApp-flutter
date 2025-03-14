import 'package:torch_light/torch_light.dart';

class FlashService {
  Future<void> flash() async {
    try {
      // Active le flash pendant 3 secondes
      await TorchLight.enableTorch();
      await Future.delayed(Duration(seconds: 3));
      await TorchLight.disableTorch();
    } catch (e) {
      print('Erreur lors de l’utilisation du flash: $e');
    }
  }
}
