import 'package:flutter_deriv_bloc_manager/manager.dart';
import 'package:flutter_derivp2p_sample/api/binary_api_wrapper.dart';

/// Interface for blocs that need Deriv ping Connection status.
abstract class DerivPingEventListener implements BaseEventListener {
  /// On ping socket init or connecting
  void onPingInitOrConnecting();

  /// On ping socket error or disconnect
  void onPingErrorOrDisconnect(String error);

  /// On ping socket connected.
  void onPingConnected(BinaryAPIWrapper apiWrapper);
}
