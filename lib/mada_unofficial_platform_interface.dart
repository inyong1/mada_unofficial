import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'mada_unofficial_method_channel.dart';

abstract class MadaUnofficialPlatform extends PlatformInterface {
  /// Constructs a MadaUnofficialPlatform.
  MadaUnofficialPlatform() : super(token: _token);

  static final Object _token = Object();

  Function(String?)? callback;

  static MadaUnofficialPlatform _instance = MethodChannelMadaUnofficial();

  /// The default instance of [MadaUnofficialPlatform] to use.
  ///
  /// Defaults to [MethodChannelMadaUnofficial].
  static MadaUnofficialPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [MadaUnofficialPlatform] when
  /// they register themselves.
  static set instance(MadaUnofficialPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  void sendPurchaseCommand({
    required double amount,
    required String ecrNumber,
    required String terminalId,
  });
}
