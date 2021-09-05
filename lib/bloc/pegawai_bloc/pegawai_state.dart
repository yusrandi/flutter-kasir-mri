
import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/pegawai_model.dart';

abstract class PegawaiState extends Equatable{}

class PegawaiInitialState extends PegawaiState {
  @override
  List<Object> get props => [];
}

class PegawaiLoadingState extends PegawaiState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class PegawaiLoadedState extends PegawaiState {
  List<Pegawai> pegawais;
  PegawaiLoadedState(this.pegawais);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class PegawaiSuccessState extends PegawaiState {
  String msg;
  PegawaiSuccessState(this.msg);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class PegawaiErrorState extends PegawaiState {
  String msg;
  PegawaiErrorState(this.msg);

  @override
  List<Object> get props => [];
}