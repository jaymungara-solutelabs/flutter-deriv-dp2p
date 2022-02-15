import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_derivp2p_sample/api/binary_api_wrapper.dart';
import 'package:flutter_derivp2p_sample/api/response/advert.dart';
import 'package:flutter_derivp2p_sample/core/bloc_manager/event_listeners/deriv_ping_event_listener.dart';

part 'advert_list_state.dart';

/// Adverts cubit for managing active symbol state.
class AdvertListCubit extends Cubit<AdvertListState>
    implements DerivPingEventListener {
  /// Initializes Adverts state.
  AdvertListCubit() : super(AdvertListInitialState());

  BinaryAPIWrapper? _binaryAPIWrapper;

  /// fetch limit for pagination
  final int defaultDataFetchLimit = 10;

  /// list of adverts
  final List<Advert> _adverts = <Advert>[];

  /// fetch list of adverts
  Future<void> fetchAdverts() async {
    try {
      final int offset = _adverts.length ~/ defaultDataFetchLimit;
      if (offset == 0) {
        emit(AdvertListLoadingState());
      }

      dev.log('_binaryAPIWrapper : $_binaryAPIWrapper');
      if (_binaryAPIWrapper != null) {
        final Map<String, dynamic>? advertListResponse = await _binaryAPIWrapper
            ?.p2pAdvertList(offset: offset, counterpartyType: 'buy', limit: 10)
            .timeout(const Duration(seconds: 15));
        if (advertListResponse?['error'] != null) {
          emit(AdvertListErrorState(advertListResponse?['error']));
        }

        final List<dynamic> list =
            advertListResponse?['p2p_advert_list']['list'];
        if (list.isNotEmpty) {
          if (offset == 0) {
            _adverts.clear();
          }
          for (final Map<String, dynamic> response in list) {
            _adverts.add(Advert.fromMap(response));
          }
        }

        dev.log('_adverts : ${_adverts.length}');
        emit(AdvertListLoadedState(
            adverts: _adverts,
            hasRemaining: list.length >= defaultDataFetchLimit));
      } else {
        emit(AdvertListErrorState('Something went wrong.'));
      }
    } on Exception catch (e) {
      dev.log('$AdvertListCubit fetchAdverts() error: $e');

      emit(AdvertListErrorState('$e'));
    }
  }

  @override
  void onPingConnected(BinaryAPIWrapper apiWrapper) {
    _binaryAPIWrapper = apiWrapper;
  }

  @override
  void onPingErrorOrDisconnect(String error) {
    _binaryAPIWrapper = null;
  }

  @override
  void onPingInitOrConnecting() {}
}
