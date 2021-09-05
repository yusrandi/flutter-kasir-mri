import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/produk_model.dart';

abstract class ProdukEvent extends Equatable {}

class FetchProdukEvent extends ProdukEvent {
  FetchProdukEvent();
  @override
  List<Object> get props => [];
}

class FetchProdukEventByIdKategori extends ProdukEvent {
  final int id;

  FetchProdukEventByIdKategori({required this.id});
  @override
  List<Object> get props => [];
}
class ProdukStoreEvent extends ProdukEvent {
  File? file;
  final Produk produk;

  ProdukStoreEvent({this.file, required this.produk});
  @override
  List<Object> get props => [];
}

class ProdukUpdateEvent extends ProdukEvent {
  final File file;
  final String id;
  final Produk produk;

  ProdukUpdateEvent({
    required this.file,
    required this.id,
    required this.produk,
  });
  @override
  List<Object> get props => [];
}

class ProdukDeleteEvent extends ProdukEvent {
  final String id;

  ProdukDeleteEvent({
    required this.id,
  });
  @override
  List<Object> get props => [];
}
