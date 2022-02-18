import 'package:flutter/material.dart';
import 'package:flutter_derivp2p_sample/api/response/advert.dart';

/// AdvertItem
class AdvertItem extends StatelessWidget {
  /// Init Widget
  const AdvertItem({required this.item, Key? key}) : super(key: key);

  /// advert item
  final Advert item;

  @override
  Widget build(BuildContext context) => Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Name : ${item.advertiserDetails?.name ?? ''}'),
          const SizedBox(height: 8),
          Text('Description : ${item.description ?? ''}'),
          const SizedBox(height: 8),
          Text('ID : ${item.id ?? ''}'),
          const SizedBox(height: 8),
          Text('Amount : ${item.priceDisplay}'),
          const SizedBox(height: 8),
          Text('Country : ${item.country}'),
          const SizedBox(height: 8),
          Text('Completed Orders : '
              '${item.advertiserDetails?.ordersCount ?? 0}'),
        ],
      ),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          boxShadow: const <BoxShadow>[
            BoxShadow(color: Colors.grey, blurRadius: 6, spreadRadius: 2)
          ]));
}
