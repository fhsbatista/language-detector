import 'package:language_detector/modules/detector/domain/entities/language.dart';

abstract class DetectorRemoteDatasource {
  Future<Language> getLanguage(String input);
}