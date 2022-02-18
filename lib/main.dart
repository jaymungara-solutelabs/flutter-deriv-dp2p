import 'dart:async';
import 'dart:developer' as logger;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_derivp2p_sample/app.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Colors.black,
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark));

  // Force a portrait orientation
  SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);

  runZonedGuarded(() async {
    runApp(const App());
  }, (Object error, StackTrace stackTrace) {
    logger.log('Error: ', error: error, stackTrace: stackTrace);
  });
}
