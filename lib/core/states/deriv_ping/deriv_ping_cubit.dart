import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_derivp2p_sample/api/binary_api_wrapper.dart';

part 'deriv_ping_state.dart';

/// Deriv ping cubit for managing active symbol state.
class DerivPingCubit extends Cubit<DerivPingState> {
  /// Initializes ping cubit.
  DerivPingCubit() : super(DerivPingInitialState());

  late BinaryAPIWrapper _api;

  /// Exposes binary API, it is mainly used in the ping method at
  /// ConnectionService.
  BinaryAPIWrapper get binaryApi => _api;

  /// init web socket
  Future<void> initWebSocket() async {
    try {
      emit(DerivPingLoadingState());
      _api = BinaryAPIWrapper(uniqueKey: UniqueKey());

      await _api.close();
      await _api.run(onOpen: (UniqueKey? uniqueKey) {
        dev.log('onOpen : $uniqueKey');
      }, onDone: (UniqueKey? uniqueKey) {
        dev.log('onDone : $uniqueKey');
      }, onError: (UniqueKey? uniqueKey) {
        dev.log('onError : $uniqueKey');
        emit(DerivPingErrorState('Ping connection failed...'));
      });

      final Map<String, dynamic> response =
          await _api.ping().timeout(const Duration(seconds: 15));
      if (response['ping'] != 'pong') {
        /// not connected
        emit(DerivPingErrorState('Ping connection failed...'));
      }

      final Map<String, dynamic> authResponse = await _api
          .authorize('cvQjBxxzoBhWgy5')
          .timeout(const Duration(seconds: 15));
      if (authResponse['error'] == null) {
        emit(DerivPingErrorState('Authorisation error...'));
      }

      emit(DerivPingLoadedState(api: _api));
    } on Exception catch (e) {
      emit(DerivPingErrorState('$e'));
    }
  }
}
