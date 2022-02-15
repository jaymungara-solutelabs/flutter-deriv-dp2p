import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_deriv_bloc_manager/bloc_managers/bloc_manager.dart';
import 'package:flutter_derivp2p_sample/features/presentation/pages/advert_list_page.dart';
import 'package:flutter_derivp2p_sample/features/presentation/widgets/center_text_widget.dart';
import 'package:flutter_derivp2p_sample/features/states/deriv_ping/deriv_ping_cubit.dart';

/// RootPage which manages connection listening point
class RootPage extends StatefulWidget {
  /// Initialise RootPage
  const RootPage({Key? key}) : super(key: key);

  /// Route Page route name.
  static const String routeName = 'root_page';

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  late DerivPingCubit _derivPingCubit;

  @override
  void initState() {
    super.initState();

    _derivPingCubit = BlocManager.instance.fetch<DerivPingCubit>();
    _derivPingCubit.initWebSocket();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Dashboard Title')),
        body: BlocBuilder<DerivPingCubit, DerivPingState>(
          bloc: _derivPingCubit,
          builder: (BuildContext context, DerivPingState state) {
            if (state is DerivPingLoadedState) {
              return const AdvertListPage();
            } else if (state is DerivPingLoadingState) {
              return const CenterTextWidget(title: 'Connecting...');
            } else if (state is DerivPingErrorState) {
              return CenterTextWidget(title: 'State\n${state.errorMessage}');
            }

            return Container();
          },
        ),
      );
}
