import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:language_detector/modules/core/error/failure.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';
import 'package:language_detector/modules/detector/domain/usecases/get_language_usecase.dart';

part 'detector_event.dart';
part 'detector_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server failed';
const String CACHE_FAILURE_MESSAGE = 'Cache failed';

class DetectorBloc extends Bloc<DetectorEvent, DetectorState> {
  final GetLanguageUsecase getLanguageUsecase;

  DetectorBloc({required this.getLanguageUsecase}) : super(EmptyState());

  @override
  Stream<DetectorState> mapEventToState(DetectorEvent event) async* {
    if (event is GetLanguageEvent) {
      yield LoadingState();
      final result = await getLanguageUsecase(GetLanguageParams(input: event.text));
      yield* result.fold(
        (failure) async* {
          yield ErrorState(failure.getErrorMessage());
        },
        (language) async* {
          yield LoadedState(language);
        },
      );
    }
  }
}

extension on Failure {
  String getErrorMessage() {
    switch (this.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      case CacheFailure:
        return CACHE_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
