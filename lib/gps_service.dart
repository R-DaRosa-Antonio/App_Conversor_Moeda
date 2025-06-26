import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';

class GpsService {
  static Future<Position?> obterLocalizacao(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    // Verifica se o serviço de localização está ativado
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _mostrarMensagem(context, 'Serviço de localização desativado.');
      return null;
    }

    // Verifica permissão
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _mostrarMensagem(context, 'Permissão de localização negada.');
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _mostrarMensagem(context, 'Permissão permanentemente negada.');
      return null;
    }

    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
    } catch (e) {
      _mostrarMensagem(context, 'Erro ao obter localização: $e');
      return null;
    }
  }

  static void _mostrarMensagem(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
