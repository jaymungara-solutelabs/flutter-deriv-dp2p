import 'dart:async';
import 'dart:developer' as logger;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/base_bloc_manager.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';
import 'package:flutter_deriv_bloc_manager/bloc_observer.dart';
import 'package:flutter_deriv_bloc_manager/event_dispatcher.dart';
import 'package:flutter_derivp2p_sample/app.dart';
import 'package:flutter_derivp2p_sample/core/bloc_manager/state_emitters/deriv_ping_state_emitter.dart';
import 'package:flutter_derivp2p_sample/features/states/advert_list/advert_list_cubit.dart';
import 'package:flutter_derivp2p_sample/features/states'
    '/deriv_ping/deriv_ping_cubit.dart';

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

  Bloc.observer = CubitObserver();

  runZonedGuarded(() async {
    registerCoreBlocs();
    initializeEventDispatcher();

    runApp(const App());
  }, (Object error, StackTrace stackTrace) {
    logger.log('Error: ', error: error, stackTrace: stackTrace);
  });
}

/// Registers common bloc and cubit to BlocManager
void registerCoreBlocs() {
  BlocManager.instance
    ..register(DerivPingCubit())
    ..register(AdvertListCubit());
}

/// Initializes event dispatcher.
void initializeEventDispatcher() {
  EventDispatcher(BlocManager.instance)
      .register<DerivPingCubit, DerivPingStateEmitter>(
          (BaseBlocManager blocManager) => DerivPingStateEmitter(blocManager));
}
