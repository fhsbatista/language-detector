import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/core/usecase.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:language_detector/modules/detector/domain/repository/detector_repository.dart';

class GetLanguageUsecase extends Usecase<Language, GetLanguageParams> {
  final DetectorRepository repository;

  GetLanguageUsecase({required this.repository});

  @override
  Future<Either<Failure, Language>> call(GetLanguageParams params) {
    return repository.getLanguage(params.input);
  }
}

class GetLanguageParams extends Equatable {
  final String input;

  GetLanguageParams({required this.input});

  @override
  List<Object?> get props => [input];
}
