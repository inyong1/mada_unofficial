import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mada_unofficial/mada_unofficial_method_channel.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  MethodChannelMadaUnofficial platform = MethodChannelMadaUnofficial();
  const MethodChannel channel = MethodChannel('mada_unofficial');

  setUp(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      channel,
      (MethodCall methodCall) async {
        return '42';
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(channel, null);
  });

  test('getPlatformVersion', () async {
    expect(await platform.getPlatformVersion(), '42');
  });
}
