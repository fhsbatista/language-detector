part of 'detector_bloc.dart';

abstract class DetectorState extends Equatable {
  const DetectorState();
}

class DetectorEmpty extends DetectorState {
  @override
  List<Object> get props => [];
}

class DetectorLoading extends DetectorState {
  @override
  List<Object?> get props => [];
}

class DetectorError extends DetectorState {
  final String msg;

  DetectorError(this.msg);

  @override
  List<Object?> get props => [msg];
}

class DetectorLoaded extends DetectorState {
  final Language language;

  DetectorLoaded(this.language);

  @override
  List<Object?> get props => [language];
}
