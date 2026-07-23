import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';

// kguanoluisa, Servicio de narracion de audio con control de velocidad y volumen por perfil, variables v_audioPlayer, v_velocidad y v_volumen, 2026-07-23
class AudioNarrationService {
  AudioNarrationService() : vAudioPlayer = AudioPlayer();

  final AudioPlayer vAudioPlayer;
  double vVelocidad = 1.0;
  double vVolumen = 1.0;

  Future<void> configurar({required double velocidad, required double volumen}) async {
    vVelocidad = velocidad.clamp(0.5, 2.0);
    vVolumen = volumen.clamp(0.0, 1.0);
    await vAudioPlayer.setSpeed(vVelocidad);
    await vAudioPlayer.setVolume(vVolumen);
  }

  Future<void> reproducirAsset(String assetPath) async {
    if (assetPath.isEmpty) {
      return;
    }
    await vAudioPlayer.setAsset(assetPath);
    await vAudioPlayer.setSpeed(vVelocidad);
    await vAudioPlayer.setVolume(vVolumen);
    await vAudioPlayer.play();
  }

  Future<void> pausar() => vAudioPlayer.pause();
  Future<void> detener() => vAudioPlayer.stop();

  Future<void> dispose() async {
    await vAudioPlayer.dispose();
  }
}

// kguanoluisa, Retroalimentacion multimodal visual, auditiva y haptica para actividades, sin nuevas variables, 2026-07-23
class MultimodalFeedback {
  static Future<void> success(BuildContext context, {String mensaje = '¡Lo lograste!'}) async {
    HapticFeedback.lightImpact();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensaje),
        backgroundColor: Theme.of(context).colorScheme.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(milliseconds: 1800),
      ),
    );
  }

  static Future<void> intento(BuildContext context) async {
    HapticFeedback.selectionClick();
    if (!context.mounted) {
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Inténtalo de nuevo, ¡tú puedes!'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
