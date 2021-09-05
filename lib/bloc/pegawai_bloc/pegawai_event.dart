import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/pegawai_model.dart';

abstract class PegawaiEvent extends Equatable{}
class FetchPegawaiEvent extends PegawaiEvent {
  FetchPegawaiEvent();
  @override
  List<Object> get props => [];
}

class PegawaiStoreEvent extends PegawaiEvent {
  final Pegawai pegawai;
  PegawaiStoreEvent({required this.pegawai});
  @override
  List<Object> get props => [];
}

class PegawaiUpdateEvent extends PegawaiEvent {
  final String id;
  final Pegawai pegawai;

  PegawaiUpdateEvent({required this.id, required this.pegawai});

  @override
  List<Object> get props => [];
}

class PegawaiDeleteEvent extends PegawaiEvent {
  final String id;
  PegawaiDeleteEvent({required this.id});

  @override
  List<Object> get props => [];
}



