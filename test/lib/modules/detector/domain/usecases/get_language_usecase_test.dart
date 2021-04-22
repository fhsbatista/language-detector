import 'package:flutter_test/flutter_test.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:language_detector/modules/detector/domain/repository/detector_repository.dart';
import 'package:language_detector/modules/detector/domain/usecases/get_language_usecase.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'get_language_usecase_test.mocks.dart';

@GenerateMocks([DetectorRepository])
void main() {
  late GetLanguageUsecase usecase;
  late MockDetectorRepository repository;

  setUp(() {
    repository = MockDetectorRepository();
    usecase = GetLanguageUsecase(repository: repository);
  });

  test('should get the language from the repository', () async {
    final input = 'hello';
    final detectedLanguage = Language(name: 'English');

    when(repository.getLanguage(any)).thenAnswer((_) async {
      return Right(detectedLanguage);
    });

    final result = await usecase.call(GetLanguageParams(input: input));

    expect(result, Right(detectedLanguage));
    verify(repository.getLanguage(input));
    verifyNoMoreInteractions(repository);
  });
}
