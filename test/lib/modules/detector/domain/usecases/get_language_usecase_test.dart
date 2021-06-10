import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:language_detector/modules/detector/domain/repository/detector_repository.dart';
import 'package:language_detector/modules/detector/domain/usecases/get_language_usecase.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectorRepository extends Mock implements DetectorRepository {}

void main() {
  late GetLanguageUsecase usecase;
  late MockDetectorRepository repository;

  setUp(() {
    repository = MockDetectorRepository();
    usecase = GetLanguageUsecase(repository: repository);
  });

  test('should return domain failure when the input is blank', () async {
    //arrange
    final input = '';
    when(() => repository.getLanguage(any())).thenAnswer((_) async {
      return Left(ServerFailure('mocked error'));
    });

    //act
    final result = await usecase.call(GetLanguageParams(input: input));

    //assert
    expect(result, Left(DomainFailure(GetLanguageUsecase.blankInputError)));
  });

  test('should get the language from the repository', () async {
    final input = 'hello';
    final detectedLanguage = Language(name: 'English');

    when(() => repository.getLanguage(any())).thenAnswer((_) async {
      return Right(detectedLanguage);
    });

    final result = await usecase.call(GetLanguageParams(input: input));

    expect(result, Right(detectedLanguage));
    verify(() => repository.getLanguage(input));
    verifyNoMoreInteractions(repository);
  });
}
