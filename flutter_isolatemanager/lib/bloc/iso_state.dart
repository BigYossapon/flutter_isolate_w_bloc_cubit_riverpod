part of 'iso_bloc.dart';

abstract class IsoState extends Equatable {
  const IsoState();

  @override
  List<Object> get props => [];
}

final class IsoInitial extends IsoState {
  @override
  List<Object> get props => [];
}

final class IsoLoading extends IsoState {
  @override
  List<Object> get props => [];
}

final class IsoLoaded extends IsoState {
  final dynamic value;
  const IsoLoaded({required this.value});
  @override
  List<Object> get props => [];
}

final class IsoError extends IsoState {
  @override
  List<Object> get props => [];
}
