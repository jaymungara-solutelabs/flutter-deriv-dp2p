import 'package:flutter_derivp2p_sample/api/response/advertiser.dart';

/// Advert Model
class Advert {
  /// Advert Const
  Advert(
      {this.accountCurrency,
      this.priceDisplay,
      this.remainingAmountDisplay,
      this.country,
      this.isActive,
      this.description,
      this.id,
      this.advertiserDetails,
      this.counterPartyType});

  /// Advert Const
  factory Advert.fromMap(Map<String, dynamic> advert) => Advert(
      accountCurrency: advert['account_currency'],
      advertiserDetails: Advertiser.fromMap(
          advert['advertiser_details'] ?? <String, dynamic>{}),
      priceDisplay: advert['price_display'],
      country: advert['country'],
      description: advert['description'],
      id: advert['id'],
      isActive: advert['is_active'] == 1,
      remainingAmountDisplay: advert['remaining_amount_display'],
      counterPartyType: advert['counterparty_type']);

  /// accountCurrency val
  final String? accountCurrency;

  /// amountDisplay val
  final String? priceDisplay;

  /// remainingAmountDisplay val
  final String? remainingAmountDisplay;

  /// country val
  final String? country;

  /// description val
  final String? description;

  /// id val
  final String? id;

  /// isActive val
  final bool? isActive;

  /// advertiserDetails val
  final Advertiser? advertiserDetails;

  /// counterPartyType val
  final String? counterPartyType;
}
