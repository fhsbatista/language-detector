import 'package:language_detector/modules/detector/domain/entities/language.dart';

abstract class DetectorLocalDatasource {
  Language get cachedLanguage;
  void cacheLanguage(Language language);
}
