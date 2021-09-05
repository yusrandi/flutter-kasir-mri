import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/absensi_model.dart';

abstract class AbsensiEvent extends Equatable {}

class FetchAbsensiEvent extends AbsensiEvent {
  FetchAbsensiEvent();
  @override
  List<Object> get props => [];
}


class AbsensiStoreEvent extends AbsensiEvent {
  final File? file;
  final Absensi absensi;

  AbsensiStoreEvent({this.file, required this.absensi});
  @override
  List<Object> get props => [];
}

class AbsensiDeleteEvent extends AbsensiEvent {
  final String id;

  AbsensiDeleteEvent({
    required this.id,
  });
  @override
  List<Object> get props => [];
}
