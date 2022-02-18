import 'package:flutter/material.dart';
import 'package:flutter_deriv_api/basic_api/generated/api.dart';
import 'package:flutter_deriv_api/basic_api/request.dart';
import 'package:flutter_deriv_api/basic_api/response.dart';
import 'package:flutter_deriv_api/services/connection/api_manager'
    '/binary_api.dart' as deriv_api;
import 'package:flutter_deriv_api/services/connection/api_manager/connection_information.dart';
import 'package:flutter_derivp2p_sample/core/helpers/json_helper.dart';
import 'package:web_socket_channel/io.dart';

/// A wrapper around `flutter_deriv_api` package.
class BinaryAPIWrapper {
  /// Constructs a new BinaryAPIWrapper.
  BinaryAPIWrapper({required UniqueKey uniqueKey}) {
    _derivAPI = deriv_api.BinaryAPI(uniqueKey);
  }

  late final deriv_api.BinaryAPI _derivAPI;

  /// check web socket ping
  Future<Map<String, dynamic>> ping() => _derivAPICall(const PingRequest());

  /// authorize user
  Future<Map<String, dynamic>> authorize(String token) =>
      _derivAPICall(AuthorizeRequest(authorize: token));

  /// fetch advert list
  Future<Map<String, dynamic>> p2pAdvertList(
          {String? counterpartyType,
          int? limit,
          int? offset,
          String? searchQuery,
          String? sortBy}) =>
      _derivAPICall(P2pAdvertListRequest(
          sortBy: sortBy,
          counterpartyType: counterpartyType,
          limit: limit,
          offset: offset,
          advertiserName: searchQuery));

  Future<Map<String, dynamic>> _derivAPICall(Request request) async {
    final Response response = await _derivAPI.call<Response>(request: request);

    return _normalizeErrorObject(response);
  }

  /// Connects to API
  Future<IOWebSocketChannel?> run({
    void Function(UniqueKey? uniqueKey)? onError,
    void Function(UniqueKey? uniqueKey)? onDone,
    void Function(UniqueKey? uniqueKey)? onOpen,
  }) async {
    final ConnectionInformation connectionInformation = ConnectionInformation(
        appId: '1089', brand: 'deriv', endpoint: 'frontend.binaryws.com');

    await _derivAPI.connect(connectionInformation,
        onOpen: onOpen?.call, onDone: onDone?.call, onError: onError?.call);
  }

  /// Disconnects from API
  Future<void> close() async {
    await _derivAPI.disconnect();
  }

  Map<String, dynamic> _normalizeErrorObject(Response response) {
    final Map<String, dynamic> rawResponse = JSONHelper.decode(
      JSONHelper.encode(response.toJson()),
      convertObjectToArrayKeys: <String>[
        'p2p_payment_methods',
        'p2p_advertiser_payment_methods',
        'payment_method_details',
        'fields'
      ],
    );

    if (rawResponse['error'] == null) {
      rawResponse.remove('error');
    }

    return rawResponse;
  }
}
