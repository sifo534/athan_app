import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  String? _currentTrack;

  bool get isPlaying => _isPlaying;
  String? get currentTrack => _currentTrack;

  Future<void> initialize() async {
    _audioPlayer.onPlayerStateChanged.listen((PlayerState state) {
      _isPlaying = state == PlayerState.playing;
    });

    _audioPlayer.onDurationChanged.listen((Duration duration) {
      debugPrint('Audio duration: $duration');
    });

    _audioPlayer.onPositionChanged.listen((Duration position) {
      debugPrint('Audio position: $position');
    });
  }

  Future<void> playAthan({String reciter = 'abdul_basit'}) async {
    try {
      _currentTrack = 'Athan - $reciter';
      
      // In a real app, you would have actual audio files
      // For now, we'll use a placeholder
      const String athanPath = 'audio/athan_abdul_basit.mp3';
      
      await _audioPlayer.play(AssetSource(athanPath));
      debugPrint('Playing Athan by $reciter');
    } catch (e) {
      debugPrint('Error playing Athan: $e');
      // Fallback to system notification sound
      await playNotificationSound();
    }
  }

  Future<void> playQuranRecitation({
    required String surah,
    required String reciter,
  }) async {
    try {
      _currentTrack = '$surah - $reciter';
      
      // In a real app, you would fetch from an API or local storage
      final String quranPath = 'audio/quran/${surah}_$reciter.mp3';
      
      await _audioPlayer.play(AssetSource(quranPath));
      debugPrint('Playing $surah by $reciter');
    } catch (e) {
      debugPrint('Error playing Quran: $e');
    }
  }

  Future<void> playDhikrAudio(String dhikrName) async {
    try {
      _currentTrack = 'Dhikr - $dhikrName';
      
      final String dhikrPath = 'audio/dhikr/$dhikrName.mp3';
      
      await _audioPlayer.play(AssetSource(dhikrPath));
      debugPrint('Playing Dhikr: $dhikrName');
    } catch (e) {
      debugPrint('Error playing Dhikr: $e');
    }
  }

  Future<void> playNotificationSound() async {
    try {
      // Play a simple notification sound
      await _audioPlayer.play(AssetSource('audio/notification.mp3'));
    } catch (e) {
      debugPrint('Error playing notification sound: $e');
    }
  }

  Future<void> pause() async {
    await _audioPlayer.pause();
    debugPrint('Audio paused');
  }

  Future<void> resume() async {
    await _audioPlayer.resume();
    debugPrint('Audio resumed');
  }

  Future<void> stop() async {
    await _audioPlayer.stop();
    _currentTrack = null;
    debugPrint('Audio stopped');
  }

  Future<void> setVolume(double volume) async {
    await _audioPlayer.setVolume(volume.clamp(0.0, 1.0));
  }

  Future<void> seek(Duration position) async {
    await _audioPlayer.seek(position);
  }

  Stream<Duration> get positionStream => _audioPlayer.onPositionChanged;
  Stream<Duration?> get durationStream => _audioPlayer.onDurationChanged;
  Stream<PlayerState> get playerStateStream => _audioPlayer.onPlayerStateChanged;

  void dispose() {
    _audioPlayer.dispose();
  }
}

// Enum for different Athan reciters
enum AthanReciter {
  abdulBasit('Abdul Basit', 'abdul_basit'),
  misharyRashid('Mishary Rashid', 'mishary_rashid'),
  maherAlMueaqly('Maher Al Mueaqly', 'maher_al_mueaqly'),
  abdullahAwad('Abdullah Awad Al Juhany', 'abdullah_awad');

  const AthanReciter(this.displayName, this.fileName);
  final String displayName;
  final String fileName;
}

// Enum for Quran reciters
enum QuranReciter {
  abdulBasit('Abdul Basit', 'abdul_basit'),
  misharyRashid('Mishary Rashid', 'mishary_rashid'),
  sudais('Abdul Rahman Al-Sudais', 'sudais'),
  shuraim('Saud Al-Shuraim', 'shuraim'),
  hudhaify('Ali Al-Hudhaify', 'hudhaify');

  const QuranReciter(this.displayName, this.fileName);
  final String displayName;
  final String fileName;
}
