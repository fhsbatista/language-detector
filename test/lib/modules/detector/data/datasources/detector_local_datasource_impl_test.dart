import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:language_detector/modules/core/error/exception.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_local_datasource.dart';
import 'package:language_detector/modules/detector/data/models/language_model.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  late DetectorLocalDatasourceImpl datasource;
  late MockSharedPreferences sharedPreferences;

  setUp(() {
    sharedPreferences = MockSharedPreferences();
    datasource = DetectorLocalDatasourceImpl(sharedPreferences);
  });

  group('get cached language', () {
    test('should return the cached language', () async {
      final jsonMap = LanguageModel(name: 'japanese').toJson();
      //arrange
      when(() => sharedPreferences.getString(CACHED_LANGUAGE_KEY)).thenReturn(json.encode(jsonMap));

      //act
      final result = await datasource.cachedLanguage;

      //assert
      verify(() => sharedPreferences.getString(CACHED_LANGUAGE_KEY));
      expect(result, LanguageModel.fromJson(jsonMap));
    });

    test('when there is no cached language, should throw CachedException', () async {
      //arrange
      when(() => sharedPreferences.getString(CACHED_LANGUAGE_KEY)).thenReturn(null);

      //act
      final call = datasource.cachedLanguage;

      //assert
      expect(() => call, throwsA(isA<CacheException>()));
    });
  });

  group('cache language', () {
    test('should call sharedPreferences to cache the language', () async {
      //arrange
      final language = LanguageModel(name: 'portuguese');
      final jsonAsString = json.encode(language.toJson());
      when(() => sharedPreferences.setString(CACHED_LANGUAGE_KEY, jsonAsString))
          .thenAnswer((_) async => true);

      //act
      datasource.cacheLanguage(language);

      //assert
      verify(() => sharedPreferences.setString(CACHED_LANGUAGE_KEY, jsonAsString));
    });
  });
}
