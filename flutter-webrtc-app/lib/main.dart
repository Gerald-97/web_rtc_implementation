import 'dart:developer' as l;
import 'dart:math';
import 'package:flutter/material.dart';
import 'screens/join_screen.dart';
import 'services/signalling.service.dart';

void main() {
  // start videoCall app
  runApp(const VideoCallApp());
}

class VideoCallApp extends StatefulWidget {
  const VideoCallApp({super.key});

  @override
  State<VideoCallApp> createState() => _VideoCallAppState();
}

class _VideoCallAppState extends State<VideoCallApp> {
  // signalling server url
  late final String websocketUrl;

  // generate callerID of local user
  late final String selfCallerID;

  @override
  void initState() {
    // websocketUrl = "http://10.0.2.2:2000";
    websocketUrl = "https://gabbi-api.enyata.com/";
    selfCallerID = Random().nextInt(999999).toString().padLeft(6, '0');
    l.log("Id: $selfCallerID");
    // init signalling service
    SignallingService.init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return material app
    return MaterialApp(
      darkTheme: ThemeData.dark().copyWith(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(),
      ),
      themeMode: ThemeMode.dark,
      home: JoinScreen(selfCallerId: selfCallerID),
    );
  }
}
