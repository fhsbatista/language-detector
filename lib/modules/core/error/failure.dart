import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {}

class DomainFailure extends Failure {
  final String msg;

  DomainFailure(this.msg);

  @override
  List<Object?> get props => [msg];
}

class ServerFailure extends Failure {
  final String msg;

  ServerFailure(this.msg);

  @override
  List<Object?> get props => [msg];
}

class CacheFailure extends Failure {
  @override
  List<Object?> get props => [];
}
