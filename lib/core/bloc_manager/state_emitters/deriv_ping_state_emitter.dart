import 'package:flutter_deriv_bloc_manager/manager.dart';
import 'package:flutter_derivp2p_sample/core/bloc_manager/event_listeners/deriv_ping_event_listener.dart';
import 'package:flutter_derivp2p_sample/features/states/deriv_ping/deriv_ping_cubit.dart';

/// Connection state emitter.
class DerivPingStateEmitter
    extends BaseStateEmitter<DerivPingEventListener, DerivPingCubit> {
  /// Initializes connection state emitter.
  DerivPingStateEmitter(BaseBlocManager blocManager) : super(blocManager);

  @override
  void handleStates({
    required DerivPingEventListener eventListener,
    required Object state,
  }) {
    if (state is DerivPingLoadedState) {
      eventListener.onPingConnected(state.api);
    } else if (state is DerivPingErrorState) {
      eventListener.onPingErrorOrDisconnect(state.errorMessage);
    } else if (state is DerivPingInitialState ||
        state is DerivPingLoadingState) {
      eventListener.onPingInitOrConnecting();
    }
  }
}
