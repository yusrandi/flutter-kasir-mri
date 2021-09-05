import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/pengeluaran_modal.dart';

abstract class PengeluaranState extends Equatable{}

class PengeluaranInitialState extends PengeluaranState{

  @override
  List<Object?> get props => [];

}

class PengeluaranLoadingState extends PengeluaranState{
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class PengeluaranLoadedState extends PengeluaranState {
  List<Pengeluaran> pengeluarans;
  PengeluaranLoadedState(this.pengeluarans);
  @override
  List<Object> get props => [];
}
// ignore: must_be_immutable
class PengeluaranSuccessState extends PengeluaranState{
  String msg;
  PengeluaranSuccessState(this.msg);
  @override
  List<Object?> get props => [];

}

// ignore: must_be_immutable
class PengeluaranErrorState extends PengeluaranState{
  String msg;
  PengeluaranErrorState(this.msg);
  @override
  List<Object?> get props => [];

}