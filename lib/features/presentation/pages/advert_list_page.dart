import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';
import 'package:flutter_derivp2p_sample/api/response/advert.dart';
import 'package:flutter_derivp2p_sample/features/states/advert_list/advert_list_cubit.dart';

/// Advert Listing Page
class AdvertListPage extends StatefulWidget {
  /// Initialise AdvertListPage
  const AdvertListPage({Key? key}) : super(key: key);

  /// Route Page route name.
  static const String routeName = 'advert_list_page';

  @override
  _AdvertListPageState createState() => _AdvertListPageState();
}

class _AdvertListPageState extends State<AdvertListPage> {
  late AdvertListCubit _advertListCubit;
  final ScrollController _scrollController = ScrollController();

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }

    _advertListCubit.fetchAdverts();
  }

  @override
  void initState() {
    super.initState();

    _advertListCubit = BlocManager.instance.fetch<AdvertListCubit>();
    _advertListCubit.fetchAdverts();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: BlocBuilder<AdvertListCubit, AdvertListState>(
        bloc: _advertListCubit,
        builder: (BuildContext context, AdvertListState state) {
          dev.log('currentstate : $state');
          if (state is AdvertListLoadingState) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AdvertListLoadedState) {
            return ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                itemCount: state.hasRemaining
                    ? state.adverts.length + 1
                    : state.adverts.length,
                controller: _scrollController,
                itemBuilder: (BuildContext context, int index) {
                  if (index >= state.adverts.length) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    final Advert item = state.adverts[index];

                    return Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(item.advertiserDetails?.name ?? ''),
                            const SizedBox(height: 8),
                            Text(item.description ?? ''),
                            const SizedBox(height: 8),
                            Text('$index : ID : ${item.id}'),
                            const SizedBox(height: 8),
                            Text('Amount : ${item.amountDisplay}'),
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
                });
            // return const Center(child: Text('Advert List'));
          } else {
            return Center(child: Text('connecting... : $state'));
          }
        },
      ));
}
