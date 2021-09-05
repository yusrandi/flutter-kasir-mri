
import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/kategori_model.dart';

abstract class KategoriState extends Equatable{}

class KategoriInitialState extends KategoriState {
  @override
  List<Object> get props => [];
}

class KategoriLoadingState extends KategoriState {
  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class KategoriLoadedState extends KategoriState {
  List<Kategori> kategoris;
  KategoriLoadedState(this.kategoris);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class KategoriSuccessState extends KategoriState {
  String msg;
  KategoriSuccessState(this.msg);

  @override
  List<Object> get props => [];
}

// ignore: must_be_immutable
class KategoriErrorState extends KategoriState {
  String msg;
  KategoriErrorState(this.msg);

  @override
  List<Object> get props => [];
}