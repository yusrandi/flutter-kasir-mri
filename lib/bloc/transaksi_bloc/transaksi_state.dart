import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/transaksi_model.dart';

abstract class TransaksiState extends Equatable {}

class TransaksiInitialState extends TransaksiState {
  @override
  List<Object?> get props => [];
}

class TransaksiLoadingState extends TransaksiState {
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class TransaksiLoadedState extends TransaksiState {
  List<Transaksi> transaksis;
  int pengeluaran;
  TransaksiLoadedState(this.transaksis, this.pengeluaran);
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class TransaksiSuccessState extends TransaksiState {
  String msg;
  TransaksiSuccessState(this.msg);
  @override
  List<Object?> get props => [];
}

// ignore: must_be_immutable
class TransaksiErrorState extends TransaksiState {
  String msg;
  TransaksiErrorState(this.msg);
  @override
  List<Object?> get props => [];
}
