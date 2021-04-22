import 'package:equatable/equatable.dart';

class Language extends Equatable {
  final String name;

  Language({required this.name});

  @override
  List<Object?> get props => [name];
}