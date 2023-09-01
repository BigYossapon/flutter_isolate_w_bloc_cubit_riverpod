part of 'iso_cubit.dart';

abstract class IsoStates extends Equatable {
  const IsoStates();

  @override
  List<Object> get props => [];
}

final class IsoInitials extends IsoStates {
  @override
  List<Object> get props => [];
}

final class IsoLoadings extends IsoStates {
  @override
  List<Object> get props => [];
}

final class IsoLoadeds extends IsoStates {
  final dynamic value;
  const IsoLoadeds({required this.value});
  @override
  List<Object> get props => [this.value];
}

final class IsoErrors extends IsoStates {
  @override
  List<Object> get props => [];
}
