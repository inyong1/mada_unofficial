import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mada_unofficial/mada_unofficial.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';
  List<String?> _callbacks = [];
  late final MadaUnofficial _madaUnofficialPlugin;
  final _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _madaUnofficialPlugin = MadaUnofficial(_madaCallback);
    initPlatformState();
  }

  void _madaCallback(String? callback) {
    setState(() {
      _callbacks.add(callback);
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      platformVersion =
          await _madaUnofficialPlugin.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(child: TextField(controller: _amountController)),
                  ElevatedButton(
                      onPressed: () {
                        final amount = double.tryParse(_amountController.text.trim()) ?? 0.0;
                        if (amount == 0.0) {
                          return;
                        }
                        _madaUnofficialPlugin.sendPurchaseCommand(amount: amount);
                      },
                      child: const Text("Purchase"))
                ],
              ),
              Expanded(
                child: Center(
                  child: ListView(children: _callbacks.map((e) => Text("$e")).toList()),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
