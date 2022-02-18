part of 'deriv_ping_cubit.dart';

/// Base state for web ping connect
abstract class DerivPingState {}

/// web ping connect initial state
class DerivPingInitialState extends DerivPingState {}

/// web ping connect loading state
class DerivPingLoadingState extends DerivPingState {}

/// web ping connect loaded state
class DerivPingLoadedState extends DerivPingState {
  /// init state
  DerivPingLoadedState({required this.api});

  /// BinaryAPIWrapper instance
  BinaryAPIWrapper api;
}

/// web ping connect error state
class DerivPingErrorState extends DerivPingState {
  /// Initializes
  DerivPingErrorState(this.errorMessage);

  /// Error message
  final String errorMessage;
}
