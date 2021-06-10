import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:language_detector/modules/core/error/exception.dart';
import 'package:language_detector/modules/core/http/urls.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_remote_datasource.dart';
import 'package:language_detector/modules/detector/data/models/language_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  late DetectorRemoteDatasourceImpl datasource;
  late MockHttpClient mockHttpClient;

  final languageFixture = fixture('detect.json');

  setUpAll(() {
    registerFallbackValue(Uri.parse(''));
  });

  setUp(() {
    mockHttpClient = MockHttpClient();
    datasource = DetectorRemoteDatasourceImpl(client: mockHttpClient);
  });

  void setHttpClientSuccess() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response(languageFixture, 200));
  }

  void setHttpClientFailure() {
    when(() => mockHttpClient.get(any(), headers: any(named: 'headers')))
        .thenAnswer((_) async => http.Response('something went wrong', 404));
  }

  test('should perform a GET request with correct body and application/json header', () async {
    //arrange
    setHttpClientSuccess();

    //act
    await datasource.getLanguage('hello');

    //assert
    verify(() => mockHttpClient.get(
          Uri.parse(Urls.detect),
          headers: {'Content-Type': 'application/json'},
        ));
  });

  test('should return the proper Language when status code is 200', () async {
    //arrange
    final expectedLanguage = LanguageModel.fromJson(json.decode(languageFixture));
    setHttpClientSuccess();

    //act
    final result = await datasource.getLanguage(expectedLanguage.name);

    //assert
    expect(result, expectedLanguage);
  });

  test('should throw a ServerException when the status code is different than 200', () {
    //arrange
    setHttpClientFailure();

    //act
    final call = datasource.getLanguage('hello');

    //assert
    exp ect(() => call, throwsA(isA<ServerException>()));
  });
}

//colocar padding na stirng
//lancar erros quando nao acha module, level e clazz
