import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/produk_model.dart';

abstract class ProdukState extends Equatable{}

class ProdukInitialState extends ProdukState{

  @override
  List<Object?> get props => [];

}

class ProdukLoadingState extends ProdukState{
  @override
  List<Object?> get props => [];
}

class ProdukLoadedState extends ProdukState {
  List<Produk> produks;
  ProdukLoadedState(this.produks);
  @override
  List<Object> get props => [];
}
class ProdukSuccessState extends ProdukState{
  String msg;
  ProdukSuccessState(this.msg);
  @override
  List<Object?> get props => [];

}

class ProdukErrorState extends ProdukState{
  String msg;
  ProdukErrorState(this.msg);
  @override
  List<Object?> get props => [];

}