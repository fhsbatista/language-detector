import 'package:connectivity/connectivity.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:language_detector/modules/core/platform/network_info.dart';
import 'package:language_detector/modules/core/platform/network_info_impl.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_local_datasource.dart';
import 'package:language_detector/modules/detector/data/datasources/detector_remote_datasource.dart';
import 'package:language_detector/modules/detector/data/repositories/detector_repository_impl.dart';
import 'package:language_detector/modules/detector/domain/repository/detector_repository.dart';
import 'package:language_detector/modules/detector/domain/usecases/get_language_usecase.dart';
import 'package:language_detector/modules/detector/presentation/detector_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  //Features
  //Bloc
  getIt.registerFactory(() => DetectorBloc(getLanguageUsecase: getIt()));

  //Usecases
  getIt.registerLazySingleton(() => GetLanguageUsecase(repository: getIt()));

  //Repositories
  getIt.registerLazySingleton<DetectorRepository>(
    () => DetectorRepositoryImpl(
      networkInfo: getIt(),
      localDatasource: getIt(),
      remoteDatasource: getIt(),
    ),
  );

  //Datasources
  getIt.registerLazySingleton<DetectorLocalDatasource>(
    () => DetectorLocalDatasourceImpl(
      sharedPreferences: getIt(),
    ),
  );
  getIt.registerLazySingleton<DetectorRemoteDatasource>(
    () => DetectorRemoteDatasourceImpl(
      client: getIt(),
    ),
  );

  //Core
  getIt.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(connectivity: getIt()));

  //External
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);
  getIt.registerLazySingleton(() => http.Client());
  getIt.registerLazySingleton(() => Connectivity());
}
