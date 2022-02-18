import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_derivp2p_sample/api/binary_api_wrapper.dart';
import 'package:flutter_derivp2p_sample/core/states/deriv_ping/deriv_ping_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockDerivPingCubit extends MockCubit<DerivPingState>
    implements DerivPingCubit {}

class FakeDerivPingState extends Fake implements DerivPingState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDerivPingState());
  });

  group('deriv ping cubit test () => ', () {
    final Exception exception = Exception('deriv ping cubit exception.');
    blocTest<DerivPingCubit, DerivPingState>(
      'deriv ping cubit captures exceptions => (deriv_ping_cubit).',
      build: () => DerivPingCubit(),
      act: (DerivPingCubit cubit) => cubit.addError(exception),
      errors: () => <Matcher>[equals(exception)],
    );

    test('test2', () async {
      final MockDerivPingCubit derivPingCubit = MockDerivPingCubit();

      whenListen(
          derivPingCubit,
          Stream<DerivPingState>.fromIterable(<DerivPingState>[
            DerivPingInitialState(),
            DerivPingLoadingState(),
            DerivPingLoadedState(api: BinaryAPIWrapper(uniqueKey: UniqueKey()))
          ]));

      await expectLater(
          derivPingCubit.stream,
          emitsInOrder(<dynamic>[
            isA<DerivPingInitialState>(),
            isA<DerivPingLoadingState>(),
            isA<DerivPingLoadedState>(),
          ]));

      final DerivPingLoadedState currentState =
          derivPingCubit.state as DerivPingLoadedState;
      expect(currentState, isA<DerivPingLoadedState>());

      expect(currentState.api, isNotNull);
      expect(currentState.api, isA<BinaryAPIWrapper>());
    });

    final MockDerivPingCubit mockDerivPingCubit = MockDerivPingCubit();
    blocTest<MockDerivPingCubit, DerivPingState>(
      'should fetch deriv ping with expect states () =>',
      build: () => mockDerivPingCubit,
      verify: (MockDerivPingCubit cubit) async {
        expect(cubit.state, isA<DerivPingLoadingState>());
        await expectLater(cubit.state, isA<DerivPingLoadedState>());
        final DerivPingLoadedState currentState =
            cubit.state as DerivPingLoadedState;
        expect(currentState, isA<DerivPingLoadedState>());

        expect(currentState.api, isNotNull);
        expect(currentState.api, isA<BinaryAPIWrapper>());
      },
      act: (DerivPingCubit a) => a.initWebSocket(),
      expect: () => <dynamic>[
        isA<DerivPingLoadingState>(),
        isA<DerivPingLoadedState>(),
      ],
    );
  });
}
