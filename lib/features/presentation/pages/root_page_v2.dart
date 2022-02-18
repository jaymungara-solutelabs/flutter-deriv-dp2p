// import 'dart:developer' as dev;
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_derivp2p_sample/features/presentation/widgets/advert_item.dart';
// import 'package:flutter_derivp2p_sample/features/presentation/widgets/center_text_widget.dart';
// import 'package:flutter_derivp2p_sample/features/states/advert_list/advert_list_cubit.dart';
// import 'package:flutter_derivp2p_sample/features/states/deriv_ping/deriv_ping_cubit.dart';
//
// /// RootPage which manages connection listening point
// class RootPage extends StatefulWidget {
//   /// Initialise RootPage
//   const RootPage({Key? key}) : super(key: key);
//
//   /// Route Page route name.
//   static const String routeName = 'root_page';
//
//   @override
//   _RootPageState createState() => _RootPageState();
// }
//
// class _RootPageState extends State<RootPage> {
//   late DerivPingCubit _derivPingCubit;
//   late AdvertListCubit _advertListCubit;
//   final ScrollController _scrollController = ScrollController();
//
//   void _onScroll() {
//     if (_scrollController.position.maxScrollExtent !=
//         _scrollController.offset) {
//       return;
//     }
//
//     _advertListCubit.fetchAdverts();
//   }
//
//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//
//     _derivPingCubit = BlocProvider.of<DerivPingCubit>(context);
//     _advertListCubit =
//         AdvertListCubit(binaryAPIWrapper: _derivPingCubit.binaryApi);
//   }
//
//   @override
//   void initState() {
//     super.initState();
//
//     _scrollController.addListener(_onScroll);
//   }
//
//   @override
//   Widget build(BuildContext context) => Scaffold(
//     appBar: AppBar(title: const Text('Dashboard Title')),
//     body: BlocBuilder<DerivPingCubit, DerivPingState>(
//       bloc: _derivPingCubit,
//       builder: (BuildContext context, DerivPingState state) {
//         dev.log('root page state : $state');
//         if (state is DerivPingLoadedState) {
//           return BlocProvider<AdvertListCubit>.value(
//             value: _advertListCubit..fetchAdverts(),
//             child: BlocBuilder<AdvertListCubit, AdvertListState>(
//               builder: (BuildContext context, AdvertListState state) {
//                 dev.log('advert list page state : $state');
//                 if (state is AdvertListLoadingState) {
//                   return const Center(child: CircularProgressIndicator());
//                 } else if (state is AdvertListLoadedState) {
//                   return ListView.builder(
//                       shrinkWrap: true,
//                       physics: const BouncingScrollPhysics(),
//                       itemCount: state.hasRemaining
//                           ? state.adverts.length + 1
//                           : state.adverts.length,
//                       controller: _scrollController,
//                       itemBuilder: (BuildContext context, int index) {
//                         if (index >= state.adverts.length) {
//                           return const Center(
//                               child: CircularProgressIndicator());
//                         } else {
//                           return AdvertItem(item: state.adverts[index]);
//                           // _buildAdvertListItems(state.adverts,
//                           // index, context)
//                         }
//                       });
//                   // return const Center(child: Text('Advert List'));
//                 } else {
//                   return Center(child: Text('connecting... : $state'));
//                 }
//               },
//             ),
//           );
//         } else if (state is DerivPingLoadingState) {
//           return const CenterTextWidget(title: 'Connecting...');
//         } else if (state is DerivPingErrorState) {
//           return CenterTextWidget(title: 'State\n${state.errorMessage}');
//         }
//
//         return Container();
//       },
//     ),
//   );
// }
