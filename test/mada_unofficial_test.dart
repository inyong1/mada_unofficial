import 'package:flutter_test/flutter_test.dart';
import 'package:mada_unofficial/mada_unofficial.dart';
import 'package:mada_unofficial/mada_unofficial_platform_interface.dart';
import 'package:mada_unofficial/mada_unofficial_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockMadaUnofficialPlatform
    with MockPlatformInterfaceMixin
    implements MadaUnofficialPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
  
  @override
  Function(String? p1)? callback;
  
  @override
  void sendPurchaseCommand({required double amount, String ecrNumber = "12345678", String terminalId = "000001"}) {
   
  }
}

void main() {
  final MadaUnofficialPlatform initialPlatform = MadaUnofficialPlatform.instance;

  test('$MethodChannelMadaUnofficial is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelMadaUnofficial>());
  });

  test('getPlatformVersion', () async {
    MadaUnofficial madaUnofficialPlugin = MadaUnofficial((a){});
    MockMadaUnofficialPlatform fakePlatform = MockMadaUnofficialPlatform();
    MadaUnofficialPlatform.instance = fakePlatform;

    expect(await madaUnofficialPlugin.getPlatformVersion(), '42');
  });
}
