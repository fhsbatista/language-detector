part of 'detector_bloc.dart';

abstract class DetectorEvent extends Equatable {
  const DetectorEvent();
}

class GetLanguageEvent extends DetectorEvent {
  final String text;

  GetLanguageEvent(this.text) : super();

  @override
  List<Object?> get props => [text];
}
