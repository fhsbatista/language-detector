import 'package:dartz/dartz.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';

abstract class DetectorRepository {
  Future<Either<Failure, Language>> getLanguage(String input);
}