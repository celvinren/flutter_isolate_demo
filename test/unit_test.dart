import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Counter increments smoke test', () async {
    final text = await _spawnAndReceive('Calvin');
    print('Received String $text');
  });
}

Future<String> _spawnAndReceive(String name) async {
  final resultPort = ReceivePort();
  await Isolate.spawn(_spawnFunction, [resultPort.sendPort, name]);

  return (await resultPort.first) as String;
}

Future<void> _spawnFunction(List<dynamic> args) async {
  SendPort responsePort = args[0];
  String name = args[1];

  final result = await _getGreeting(name);

  Isolate.exit(responsePort, result);
}

Future<String> _getGreeting(String name) async {
  final newString = 'Hello $name ${Random().nextInt(100)}';

  /// Make the thread sleep for 10 seconds
  sleep(const Duration(seconds: 10));

  return newString;
}
