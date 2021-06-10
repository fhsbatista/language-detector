import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/core/usecase.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:language_detector/modules/detector/domain/repository/detector_repository.dart';

class GetLanguageUsecase extends Usecase<Language, GetLanguageParams> {
  static const blankInputError = 'Tried to detect the language of a blank input';
  final DetectorRepository repository;

  GetLanguageUsecase({required this.repository});

  @override
  Future<Either<Failure, Language>> call(GetLanguageParams params) async {
    if (isInputValid(params.input)) {
      return repository.getLanguage(params.input);
    } else {
      return Left(DomainFailure(getInputError(params.input)));
    }
  }

  bool isInputValid(String input) {
    return input.trim().isNotEmpty;
  }

  String getInputError(String input) {
    if (input.trim().isEmpty) {
      return blankInputError;
    } else {
      throw 'This input is valid';
    }
  }
}

class GetLanguageParams extends Equatable {
  final String input;

  GetLanguageParams({required this.input});

  @override
  List<Object?> get props => [input];
}
