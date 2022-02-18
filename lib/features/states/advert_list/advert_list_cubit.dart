import 'dart:developer' as dev;

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_derivp2p_sample/api/binary_api_wrapper.dart';
import 'package:flutter_derivp2p_sample/api/response/advert.dart';

part 'advert_list_state.dart';

/// Adverts cubit for managing active symbol state.
class AdvertListCubit extends Cubit<AdvertListState> {
  /// Initializes Adverts state.
  AdvertListCubit({required this.binaryAPIWrapper})
      : super(AdvertListInitialState());

  /// BinaryAPIWrapper
  final BinaryAPIWrapper binaryAPIWrapper;

  /// fetch limit for pagination
  final int defaultDataFetchLimit = 10;

  /// list of adverts
  final List<Advert> _adverts = <Advert>[];

  /// search query
  String _searchQuery = '';

  /// String types =>
  /// 1) rate (by default)
  /// 2)completion
  int _sortType = 0;

  /// get selected sort type
  int get sortType => _sortType;

  /// get selected sort type
  bool isFetching = false;

  /// toggle sort type
  void toggleSortType(int index) {
    _sortType = index;

    _adverts.clear();
    fetchAdverts();
  }

  /// search advert query
  void searchQuery(String query) {
    _searchQuery = query;

    _adverts.clear();
    fetchAdverts();
  }

  /// fetch list of adverts
  Future<void> fetchAdverts() async {
    try {
      isFetching = true;

      final int offset = _adverts.length ~/ defaultDataFetchLimit;
      if (offset == 0) {
        emit(AdvertListLoadingState());
      }

      dev.log('_binaryAPIWrapper : $binaryAPIWrapper');
      final Map<String, dynamic>? advertListResponse = await binaryAPIWrapper
          .p2pAdvertList(
              offset: offset * defaultDataFetchLimit,
              counterpartyType: 'buy',
              limit: defaultDataFetchLimit,
              searchQuery: _searchQuery,
              sortBy: _sortType == 0 ? 'rate' : 'completion')
          .timeout(const Duration(seconds: 15));
      if (advertListResponse?['error'] != null) {
        emit(AdvertListErrorState(advertListResponse?['error']));
      }

      final List<dynamic> list = advertListResponse?['p2p_advert_list']['list'];
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
    } on Exception catch (e) {
      dev.log('$AdvertListCubit fetchAdverts() error: $e');

      emit(AdvertListErrorState('$e'));
    } finally {
      isFetching = false;
    }
  }
}
