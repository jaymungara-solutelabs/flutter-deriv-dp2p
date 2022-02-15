import 'package:flutter_derivp2p_sample/api/response/advertiser.dart';
import 'package:flutter_derivp2p_sample/utils/enums.dart';

/// Advert Model
class Advert {
  /// Advert Const
  Advert(
      {this.counterpartyType,
      this.accountCurrency,
      this.amountDisplay,
      this.remainingAmountDisplay,
      this.country,
      this.isActive,
      this.description,
      this.id,
      this.advertiserDetails});

  /// Advert Const
  factory Advert.fromMap(Map<String, dynamic> advert) => Advert(
      accountCurrency: advert['account_currency'],
      advertiserDetails: Advertiser.fromMap(
          advert['advertiser_details'] ?? <String, dynamic>{}),
      amountDisplay: advert['amount_display'],
      country: advert['country'],
      counterpartyType: advert['counterparty_type'] == 'sell'
          ? AdvertType.sell
          : AdvertType.buy,
      description: advert['description'],
      id: advert['id'],
      isActive: advert['is_active'] == 1,
      remainingAmountDisplay: advert['remaining_amount_display']);

  /// accountCurrency val
  final String? accountCurrency;

  /// amountDisplay val
  final String? amountDisplay;

  /// remainingAmountDisplay val
  final String? remainingAmountDisplay;

  /// country val
  final String? country;

  /// counterpartyType val
  final AdvertType? counterpartyType;

  /// description val
  final String? description;

  /// id val
  final String? id;

  /// isActive val
  final bool? isActive;

  /// advertiserDetails val
  final Advertiser? advertiserDetails;
}
