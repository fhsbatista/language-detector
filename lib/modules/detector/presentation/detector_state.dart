part of 'detector_bloc.dart';

abstract class DetectorState extends Equatable {
  const DetectorState();
}

class EmptyState extends DetectorState {
  @override
  List<Object> get props => [];
}

class LoadingState extends DetectorState {
  @override
  List<Object?> get props => [];
}

class ErrorState extends DetectorState {
  final String msg;

  ErrorState(this.msg);

  @override
  List<Object?> get props => [msg];
}

class LoadedState extends DetectorState {
  final Language language;

  LoadedState(this.language);

  @override
  List<Object?> get props => [language];
}
