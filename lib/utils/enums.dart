/// APIErrorType
enum APIErrorType {
  /// serverError
  serverError,

  /// restrictedCountry
  restrictedCountry,

  /// disableAccount
  disableAccount,

  /// unwelcomeAccount
  unwelcomeAccount,

  /// expiredAccount
  expiredAccount,

  /// unsupportedCurrency
  unsupportedCurrency,

  /// notAvailableCountry
  notAvailableCountry,

  /// accountNotLoaded
  accountNotLoaded,

  /// unknownError
  unknownError,
}

/// Connectivity status.
enum DisconnectSource {
  /// Wifi or mobile network is disconnected.
  internet,

  /// Websocket is disconnected.
  websocket,
}

/// AdvertType
enum AdvertType {
  /// buy AdvertType
  buy,

  /// sell AdvertType
  sell,
}
