import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_derivp2p_sample/core/states/deriv_ping/deriv_ping_cubit.dart';
import 'package:flutter_derivp2p_sample/features/presentation/pages/root_page.dart';

/// Main Page where users can manage the app task
class App extends StatefulWidget {
  /// Initializes [App]
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  final DerivPingCubit _derivPingCubit = DerivPingCubit();

  @override
  Widget build(BuildContext context) => MultiBlocProvider(
        providers: <BlocProvider<dynamic>>[
          BlocProvider<DerivPingCubit>(
              create: (_) => _derivPingCubit..initWebSocket()),
        ],
        child: MaterialApp(
            title: 'Flutter Mobile Test',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                primarySwatch: Colors.blue, brightness: Brightness.light),
            navigatorKey: _navigatorKey,
            routes: <String, WidgetBuilder>{
              RootPage.routeName: (BuildContext context) => const RootPage(),
            },
            onUnknownRoute: (RouteSettings settings) => MaterialPageRoute<void>(
                settings: settings,
                builder: (BuildContext context) => const RootPage()),
            initialRoute: RootPage.routeName),
      );
}
