import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'mada_unofficial_platform_interface.dart';

/// An implementation of [MadaUnofficialPlatform] that uses method channels.
class MethodChannelMadaUnofficial extends MadaUnofficialPlatform {
  /// The method channel used to interact with the native platform.
  ///

  @visibleForTesting
  final methodChannel = const MethodChannel('mada_unofficial');

  MethodChannelMadaUnofficial() {
    methodChannel.setMethodCallHandler(
      (call) async {
        switch (call.method) {
          case "mada_response":
            callback?.call(call.arguments);
            break;
          default:
            break;
        }
      },
    );
  }

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }

  @override
  void sendPurchaseCommand({
    required double amount,
    String ecrNumber = "12345678",
    String terminalId = "000001",
  }) {
    final map = {
      "ecr_number": ecrNumber,
      "terminal_id": terminalId,
      "amount": amount,
    };
    methodChannel.invokeMethod("purchase", jsonEncode(map));
  }
}
