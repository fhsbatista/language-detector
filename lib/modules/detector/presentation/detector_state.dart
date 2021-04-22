import 'package:equatable/equatable.dart';

abstract class DetectorState extends Equatable{}

class DetectorInitialState extends DetectorState {
  @override
  List<Object?> get props => [];
}

class DetectorLoadingState extends DetectorState {
  @override
  List<Object?> get props => [];
}

class DetectorErrorState extends DetectorState {
  final String error;


  DetectorErrorState({required this.error});

  @override
  List<Object?> get props => [];

}

class DetectorSuccessState extends DetectorState {
  final String language;

  DetectorSuccessState({required this.language});

  @override
  List<Object?> get props => [language];
}