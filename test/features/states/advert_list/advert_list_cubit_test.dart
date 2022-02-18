import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_deriv_api/api/api_initializer.dart';
import 'package:flutter_derivp2p_sample/api/binary_api_wrapper.dart';
import 'package:flutter_derivp2p_sample/features/states/advert_list'
    '/advert_list_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockAdvertListCubit extends MockCubit<AdvertListState>
    implements AdvertListCubit {}

class FakeAdvertListState extends Fake implements AdvertListState {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeAdvertListState());

    APIInitializer().initialize(isMock: true);
  });

  group('advert list cubit test () => ', () {
    final Exception exception = Exception('deriv ping cubit exception.');
    blocTest<AdvertListCubit, AdvertListState>(
        'captures exceptions => (advert_list_cubit).',
        build: () => AdvertListCubit(
            binaryAPIWrapper: BinaryAPIWrapper(uniqueKey: UniqueKey())),
        act: (AdvertListCubit cubit) => cubit.addError(exception),
        errors: () => <Matcher>[equals(exception)]);
  });
}
