import 'package:flutter/material.dart';
import 'package:flutter_derivp2p_sample/api/response/advert.dart';
import 'package:flutter_test/flutter_test.dart';

import 'advert_list_data.dart';

void main() {
  group('Advert list page widget test =>', () {
    testWidgets('Widget exists', (WidgetTester tester) async {
      await tester.pumpWidget(_TestApp(adverts: adverts, hasRemaining: true));

      await tester.idle();
      await tester.pumpAndSettle();

      expect(find.byType(ListView), findsOneWidget);
      expect(find.byType(Scrollable), findsOneWidget);
      final Finder listFinder = find.byType(Scrollable);
      final Finder itemFinder = find.byKey(const Key('item_4'));

      // Scroll until the item to be found appears.
      await tester.scrollUntilVisible(itemFinder, 500, scrollable: listFinder);
      expect(itemFinder, findsOneWidget);
    });
  });
}

/// _Test App Scaffold
class _TestApp extends StatefulWidget {
  /// Init State
  const _TestApp({required this.adverts, required this.hasRemaining});

  /// adverts list
  final List<Advert> adverts;

  /// hasRemaining
  final bool hasRemaining;

  @override
  State<_TestApp> createState() => _TestAppState();
}

class _TestAppState extends State<_TestApp> {
  @override
  Widget build(BuildContext context) => MaterialApp(
      home: Scaffold(
          body: ListView.builder(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              itemCount: widget.hasRemaining
                  ? widget.adverts.length + 1
                  : widget.adverts.length,
              itemBuilder: (BuildContext context, int index) {
                if (index >= widget.adverts.length) {
                  return const Center(child: CircularProgressIndicator());
                } else {
                  final Advert item = widget.adverts[index];

                  return Container(
                      key: Key('item_$index'),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
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
                          Text(
                            'Completed Orders : '
                            '${item.advertiserDetails?.ordersCount ?? 0}',
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          boxShadow: const <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey,
                                blurRadius: 6,
                                spreadRadius: 2)
                          ]));
                  // _buildAdvertListItems(state.adverts, index, context)
                }
              })));
}
