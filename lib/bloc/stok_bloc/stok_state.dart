import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/stok_model.dart';

abstract class StokState extends Equatable{}

class StokInitialState extends StokState{

  @override
  List<Object?> get props => [];

}

class StokLoadingState extends StokState{
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class StokLoadedState extends StokState {
  List<Stok> stoks;
  StokLoadedState(this.stoks);
  @override
  List<Object> get props => [];
}
// ignore: must_be_immutable
class StokSuccessState extends StokState{
  String msg;
  StokSuccessState(this.msg);
  @override
  List<Object?> get props => [];

}

// ignore: must_be_immutable
class StokErrorState extends StokState{
  String msg;
  StokErrorState(this.msg);
  @override
  List<Object?> get props => [];

}