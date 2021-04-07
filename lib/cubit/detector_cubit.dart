import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_detector/cubit/detector_state.dart';

class DetectorCubit extends Cubit<DetectorState>{
  DetectorCubit() : super(DetectorInitialState());

  void onDetectClick(String text) async {
    emit(DetectorLoadingState());
    await Future.delayed(const Duration(seconds: 1));
    emit(DetectorSuccessState(language: 'Spanish'));
  }
}