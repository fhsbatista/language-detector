import 'dart:convert';

import 'package:language_detector/modules/core/error/exception.dart';
import 'package:language_detector/modules/detector/data/models/language_model.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class DetectorLocalDatasource {
  Future<Language> get cachedLanguage;

  Future<void> cacheLanguage(Language language);
}

const CACHED_LANGUAGE_KEY = 'CACHED_LANGUAGE_KEY';

class DetectorLocalDatasourceImpl implements DetectorLocalDatasource {
  final SharedPreferences sharedPreferences;

  DetectorLocalDatasourceImpl({required this.sharedPreferences});

  @override
  Future<Language> get cachedLanguage async {
    try {
      final cachedJson = await json.decode(sharedPreferences.getString(CACHED_LANGUAGE_KEY) ?? '');
      return Future.value(LanguageModel.fromJson(cachedJson));
    } on FormatException {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheLanguage(Language language) {
    final jsonAsString = json.encode(LanguageModel(name: language.name).toJson());
    return sharedPreferences.setString(CACHED_LANGUAGE_KEY, jsonAsString);
  }
}
