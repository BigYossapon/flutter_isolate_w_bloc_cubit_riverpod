import 'package:equatable/equatable.dart';

class IsoStatess extends Equatable {
  const IsoStatess();

  @override
  List<Object> get props => [];
}

final class IsoInitialss extends IsoStatess {
  @override
  List<Object> get props => [];
}

final class IsoLoadingss extends IsoStatess {
  @override
  List<Object> get props => [];
}

final class IsoLoadedss extends IsoStatess {
  final dynamic value;
  const IsoLoadedss({required this.value});
  @override
  List<Object> get props => [this.value];
}

final class IsoErrorss extends IsoStatess {
  @override
  List<Object> get props => [];
}
