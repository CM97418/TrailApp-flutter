import 'package:audioplayers/audioplayers.dart';

class SpeakerService {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playAlert() async {
    // Lecture d'un fichier audio stocké dans assets/alert.mp3
    await _audioPlayer.play(AssetSource('alert.mp3'));
  }
}
