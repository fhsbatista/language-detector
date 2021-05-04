import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:language_detector/modules/core/error/exception.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/core/platform/network_info.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_local_datasource.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_remote_datasource.dart';
import 'package:language_detector/modules/detector/data/repositories/detector_repository_impl.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:mocktail/mocktail.dart';

class MockDetectorRemoteDatasource extends Mock implements DetectorRemoteDatasource {}

class MockDetectorLocalDatasource extends Mock implements DetectorLocalDatasource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late MockDetectorRemoteDatasource mockRemoteDatasource;
  late MockDetectorLocalDatasource mockLocalDatasource;
  late MockNetworkInfo mockNetworkInfo;
  late DetectorRepositoryImpl repository;

  final languageToDetect = 'hello';
  final detectedLanguage = Language(name: 'english');

  setUp(() {
    mockRemoteDatasource = MockDetectorRemoteDatasource();
    mockLocalDatasource = MockDetectorLocalDatasource();
    mockNetworkInfo = MockNetworkInfo();
    repository = DetectorRepositoryImpl(
      networkInfo: mockNetworkInfo,
      localDatasource: mockLocalDatasource,
      remoteDatasource: mockRemoteDatasource,
    );
    when(() => mockLocalDatasource.cachedLanguage).thenThrow(CacheException());
    when(() => mockLocalDatasource.cacheLanguage(detectedLanguage)).thenAnswer((_) async => true);
  });

  group('getLanguage', () {
    test('should check if has internet connection', () async {
      //arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(() => mockRemoteDatasource.getLanguage(any())).thenAnswer((_) async => detectedLanguage);

      //act
      await repository.getLanguage('hello');

      //asset
      verify(() => mockNetworkInfo.isConnected);
    });
  });

  group('when there is internet connect', () {
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
    });

    test('should return remote datasource\'s data when the call succeeds', () async {
      //arrange
      when(() => mockRemoteDatasource.getLanguage(languageToDetect))
          .thenAnswer((_) async => detectedLanguage);

      //act
      final result = await repository.getLanguage(languageToDetect);

      //assert
      verify(() => mockRemoteDatasource.getLanguage(languageToDetect));
      expect(result, equals(Right(detectedLanguage)));
    });

    test('should cache data locally when the call to remote datasource succeeds', () async {
      //arrange
      when(() => mockRemoteDatasource.getLanguage(languageToDetect))
          .thenAnswer((_) async => detectedLanguage);

      //act
      await repository.getLanguage(languageToDetect);

      //assert
      verify(() => mockRemoteDatasource.getLanguage(languageToDetect));
      verify(() => mockLocalDatasource.cacheLanguage(detectedLanguage));
    });

    test('should return a server failure when the remote datasource throws an exception', () async {
      //arrange
      when(() => mockRemoteDatasource.getLanguage(languageToDetect)).thenThrow(ServerException());

      //act
      final result = await repository.getLanguage(languageToDetect);

      //assert
      verify(() => mockRemoteDatasource.getLanguage(languageToDetect));
      verifyZeroInteractions(mockLocalDatasource);
      expect(result, Left(ServerFailure()));
    });
  });

  group('when there is no internet connection', () {
    final cachedLanguage = Language(name: 'English');
    setUp(() {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
    });

    test('should return the cached detected language', () async {
      //arrange
      when(() => mockLocalDatasource.cachedLanguage).thenAnswer((_) async => cachedLanguage);

      //act
      final result = await repository.getLanguage(languageToDetect);

      //assert
      verifyZeroInteractions(mockRemoteDatasource);
      verify(() => mockLocalDatasource.cachedLanguage);
      expect(result, Right(cachedLanguage));
    });

    test('should return CacheException when there is no cached data', () async {
      //arrange
      when(() => mockLocalDatasource.cachedLanguage).thenThrow(CacheException());

      //act
      final result = await repository.getLanguage(languageToDetect);

      //assert
      expect(result, Left(CacheFailure()));
    });
  });
}
