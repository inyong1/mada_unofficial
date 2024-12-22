import 'mada_unofficial_platform_interface.dart';

class MadaUnofficial {
  MadaUnofficial(this.callback) {
    MadaUnofficialPlatform.instance.callback = callback;
  }

  Function(String?) callback;

  Future<String?> getPlatformVersion() {
    return MadaUnofficialPlatform.instance.getPlatformVersion();
  }

  void sendPurchaseCommand({
    required double amount,
    String ecrNumber = "12345678",
    String terminalId = "000001",
  }) {
    MadaUnofficialPlatform.instance.sendPurchaseCommand(
      amount: amount,
      ecrNumber: ecrNumber,
      terminalId: terminalId,
    );
  }
}
