import 'dart:io';
import 'dart:isolate';
import 'dart:math';

import 'package:flutter/material.dart';

void main() async {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  String text = 'Start app';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Isolate demo'),
        ),
        backgroundColor: Colors.white,
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 90),
                ElevatedButton(
                  onPressed: () async {
                    /// Call _getGreeting function in the main thread
                    // final result1 = await _getGreeting('Calvin');

                    /// Call _getGreeting function in a separate thread
                    // final result2 = await _spawnAndReceive('Calvin');

                    /// Call _getGreeting function in a separate thread
                    /// using Isolate.run
                    final result3 =
                        await Isolate.run(() => _getGreeting('Calvin'));

                    setState(() {
                      text = result3;
                    });
                  },
                  child: const Text('Spawn isolates'),
                ),
                Text(
                  text,
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Test1'),
                ),
                const SizedBox(height: 500),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('Test2'),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }
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
  sleep(const Duration(seconds: 10));
  return newString;
}
