import 'package:dartz/dartz.dart';
import 'package:language_detector/modules/core/error/exception.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/core/platform/network_info.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_local_datasource.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_remote_datasource.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:language_detector/modules/detector/domain/repository/detector_repository.dart';

class DetectorRepositoryImpl implements DetectorRepository {
  final NetworkInfo networkInfo;
  final DetectorLocalDatasource localDatasource;
  final DetectorRemoteDatasource remoteDatasource;

  DetectorRepositoryImpl({
    required this.networkInfo,
    required this.localDatasource,
    required this.remoteDatasource,
  });

  @override
  Future<Either<Failure, Language>> getLanguage(String input) async {
    if (await networkInfo.isConnected) {
      try {
        networkInfo.isConnected;
        final detectedLanguage = await remoteDatasource.getLanguage(input);
        localDatasource.cacheLanguage(detectedLanguage);
        return Right(detectedLanguage);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        return Right(localDatasource.cachedLanguage);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
