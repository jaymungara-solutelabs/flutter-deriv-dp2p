import 'dart:async';
import 'dart:developer' as dev;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_derivp2p_sample/core/states/deriv_ping/deriv_ping_cubit.dart';
import 'package:flutter_derivp2p_sample/features/presentation/widgets/advert_item.dart';
import 'package:flutter_derivp2p_sample/features/states/advert_list/advert_list_cubit.dart';
import 'package:rxdart/rxdart.dart';

/// Advert Listing Page
class AdvertListWidget extends StatefulWidget {
  /// Initialise AdvertListPage
  const AdvertListWidget({Key? key}) : super(key: key);

  @override
  _AdvertListWidgetState createState() => _AdvertListWidgetState();
}

class _AdvertListWidgetState extends State<AdvertListWidget> {
  late AdvertListCubit _advertListCubit;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final BehaviorSubject<String> searchOnChange = BehaviorSubject<String>();
  StreamSubscription<void>? _periodicFetchStreamSubscription;

  void clearSearchInput() {
    searchController.clear();
    search('');
  }

  void search(String queryString) {
    searchOnChange.add(queryString);
  }

  void _onScroll() {
    if (_scrollController.position.maxScrollExtent !=
        _scrollController.offset) {
      return;
    }

    _advertListCubit.fetchAdverts();
  }

  @override
  void dispose() {
    searchOnChange.close();
    searchController.dispose();
    _periodicFetchStreamSubscription?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final DerivPingCubit _derivPingCubit = context.read<DerivPingCubit>();
    _advertListCubit =
        AdvertListCubit(binaryAPIWrapper: _derivPingCubit.binaryApi);

    _periodicFetchStreamSubscription?.cancel();

    _periodicFetchStreamSubscription = Stream<void>.periodic(
      const Duration(minutes: 1),
    ).listen((_) {
      dev.log('tick state : ${_derivPingCubit.state}');
      if (_derivPingCubit.state is DerivPingLoadedState) {
        _advertListCubit.fetchAdverts(isPeriodic: true);
      }
    });
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_onScroll);

    // search debounce
    searchOnChange
        .debounceTime(const Duration(milliseconds: 750))
        .listen((String query) {
      if (query.isNotEmpty) {
        _advertListCubit.searchQuery(query);
      } else {
        _advertListCubit.searchQuery('');
      }
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: BlocProvider<AdvertListCubit>.value(
        // value: _advertListCubit,
        value: _advertListCubit..fetchAdverts(),
        child: Column(
          children: <Widget>[
            Expanded(
              child: BlocBuilder<AdvertListCubit, AdvertListState>(
                builder: (BuildContext context, AdvertListState state) {
                  dev.log('advert list page state : $state');

                  if (state is AdvertListLoadingState ||
                      state is AdvertListLoadedState) {
                    return Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            const Padding(
                                padding: EdgeInsets.only(top: 16, bottom: 8),
                                child: Text('Sort By ',
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16))),
                            Container(
                              margin: const EdgeInsets.only(
                                  top: 16, bottom: 8, right: 16),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.circular(4)),
                              child: Row(
                                children: <Widget>[
                                  GestureDetector(
                                    onTap: () {
                                      if (_advertListCubit.sortType != 0) {
                                        _advertListCubit.toggleSortType(0);
                                      }
                                    },
                                    child: Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 16, vertical: 8),
                                        color: _advertListCubit.sortType == 0
                                            ? Colors.blueAccent
                                            : Colors.white,
                                        child: Text('rate',
                                            style: TextStyle(
                                                color:
                                                    _advertListCubit.sortType ==
                                                            0
                                                        ? Colors.white
                                                        : Colors.blueAccent))),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      if (_advertListCubit.sortType != 1) {
                                        _advertListCubit.toggleSortType(1);
                                      }
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 8),
                                      color: _advertListCubit.sortType == 1
                                          ? Colors.blueAccent
                                          : Colors.white,
                                      child: Text(
                                        'completion',
                                        style: TextStyle(
                                          color: _advertListCubit.sortType == 1
                                              ? Colors.white
                                              : Colors.blueAccent,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                              left: 16, right: 16, bottom: 8),
                          child: TextFormField(
                            onChanged: (String query) => search(query),
                            controller: searchController,
                            cursorColor: Colors.black,
                            cursorWidth: 1,
                            textInputAction: TextInputAction.done,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 16),
                            decoration: InputDecoration(
                              hintText: 'Search',
                              prefixIcon: const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Icon(Icons.search)),
                              suffixIcon: searchController.text.isNotEmpty
                                  ? GestureDetector(
                                      child: const Padding(
                                          padding: EdgeInsets.all(8),
                                          child: Icon(Icons.close)),
                                      onTap: clearSearchInput)
                                  : null,
                              fillColor: const Color(0xFFEEEEF0),
                              filled: true,
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 4),
                              focusedBorder: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              border: const OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10))),
                              enabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              disabledBorder: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        state is AdvertListLoadingState
                            ? const Expanded(
                                child:
                                    Center(child: CircularProgressIndicator()))
                            : Container(),
                        state is AdvertListLoadedState
                            ? Expanded(
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: const BouncingScrollPhysics(),
                                    itemCount: state.hasRemaining
                                        ? state.adverts.length + 1
                                        : state.adverts.length,
                                    controller: _scrollController,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      if (index >= state.adverts.length) {
                                        return const Center(
                                            child: CircularProgressIndicator());
                                      } else {
                                        return AdvertItem(
                                            item: state.adverts[index]);
                                      }
                                    }),
                              )
                            : Container()
                      ],
                    );
                  } else {
                    return Center(child: Text('connecting... : $state'));
                  }

                  // if (state is AdvertListLoadingState) {
                  //   return const Center(child: CircularProgressIndicator());
                  // } else if (state is AdvertListLoadedState) {
                  //   return Expanded(
                  //     child: ListView.builder(
                  //         shrinkWrap: true,
                  //         physics: const BouncingScrollPhysics(),
                  //         itemCount: state.hasRemaining
                  //             ? state.adverts.length + 1
                  //             : state.adverts.length,
                  //         controller: _scrollController,
                  //         itemBuilder: (BuildContext context, int index) {
                  //           if (index >= state.adverts.length) {
                  //             return const Center(
                  //                 child: CircularProgressIndicator());
                  //           } else {
                  //             return AdvertItem(item: state.adverts[index]);
                  //           }
                  //         }));
                  // } else {
                  //   return Center(child: Text('connecting... : $state'));
                  // }
                },
              ),
            )
          ],
        ),
      ));
}
