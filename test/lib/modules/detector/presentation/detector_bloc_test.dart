import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:language_detector/modules/detector/domain/usecases/get_language_usecase.dart';
import 'package:language_detector/modules/detector/presentation/detector_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetLanguageUsecase extends Mock implements GetLanguageUsecase {}

void main() {
  late MockGetLanguageUsecase getLanguageUsecase;
  late DetectorBloc bloc;

  setUpAll(() {
    registerFallbackValue(GetLanguageParams(input: ''));
  });

  setUp(() {
    getLanguageUsecase = MockGetLanguageUsecase();
    bloc = DetectorBloc(getLanguageUsecase: getLanguageUsecase);
  });

  test('initial state should be empty', () {
    expect(bloc.state, DetectorEmpty());
  });

  group('getLanguage', () {
    final input = 'hello, it is sunny today';
    final params = GetLanguageParams(input: input);
    final detectedLanguage = Language(name: 'english');

    test('should call getLanguageUsecase', () async {
      //arrange
      when(() => getLanguageUsecase(params)).thenAnswer((_) async => Right(detectedLanguage));

      //act
      bloc.add(GetLanguageEvent(input));
      await untilCalled(() => getLanguageUsecase(params));

      //assert
      verify(() => getLanguageUsecase(params));
    });

    test('should emit error when usecase returns a server failure', () async {
      //arrange
      when(() => getLanguageUsecase(params)).thenAnswer((_) async => Left(ServerFailure()));

      //assert later
      final expected = [
        DetectorLoading(),
        DetectorError(SERVER_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(GetLanguageEvent(input));
    });

    test('should emit loaded state when usecase succeeds', () async {
      //arrange
      when(() => getLanguageUsecase(params)).thenAnswer((_) async => Right(detectedLanguage));

      //assert later
      final expected = [
        DetectorLoading(),
        DetectorLoaded(detectedLanguage),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(GetLanguageEvent(input));
    });

    test('should emit error state when usecase return a cache failure', () async {
      //arrange
      when(() => getLanguageUsecase(params)).thenAnswer((_) async => Left(CacheFailure()));

      //assert later
      final expected = [
        DetectorLoading(),
        DetectorError(CACHE_FAILURE_MESSAGE),
      ];
      expectLater(bloc.stream, emitsInOrder(expected));

      //act
      bloc.add(GetLanguageEvent(input));
    });
  });
}
