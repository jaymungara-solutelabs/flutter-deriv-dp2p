import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_derivp2p_sample/api/binary_api_wrapper.dart';
import 'package:flutter_derivp2p_sample/api/response/advert.dart';
import 'package:flutter_derivp2p_sample/core/states/deriv_ping/deriv_ping_cubit.dart';
import 'package:flutter_derivp2p_sample/features/states/advert_list'
    '/advert_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdvertListCubit extends MockCubit<AdvertListState>
    implements AdvertListCubit {}

class FakeAdvertListState extends Fake implements AdvertListState {}

void main() {
  late DerivPingCubit derivPingCubit;
  late AdvertListCubit advertListCubit;

  setUpAll(() async {
    registerFallbackValue(FakeAdvertListState());

    derivPingCubit = DerivPingCubit();
    await derivPingCubit.initWebSocket();
    advertListCubit =
        AdvertListCubit(binaryAPIWrapper: derivPingCubit.binaryApi);
  });

  group('advert list cubit test () => ', () {
    final Exception exception = Exception('advert list cubit exception.');
    blocTest<AdvertListCubit, AdvertListState>(
        'captures exceptions => (advert_list_cubit).',
        build: () => AdvertListCubit(
            binaryAPIWrapper: BinaryAPIWrapper(uniqueKey: UniqueKey())),
        act: (AdvertListCubit cubit) => cubit.addError(exception),
        errors: () => <Matcher>[equals(exception)]);

    blocTest<AdvertListCubit, AdvertListState>(
      'should fetch advert list with expect states () =>',
      build: () => advertListCubit,
      verify: (AdvertListCubit cubit) async {
        expect(cubit.state, isA<AdvertListLoadingState>());
        await expectLater(cubit.state, isA<AdvertListLoadedState>());
        final AdvertListLoadedState currentState =
            cubit.state as AdvertListLoadedState;
        expect(currentState, isA<AdvertListLoadedState>());

        expect(currentState.adverts, isNotNull);
        expect(currentState.adverts, isA<List<Advert>>());
      },
      act: (AdvertListCubit a) => a.fetchAdverts(),
      expect: () => <dynamic>[
        isA<AdvertListLoadingState>(),
        isA<AdvertListLoadedState>(),
      ],
    );
  });
}
