
import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/pengeluaran_modal.dart';

abstract class PengeluaranEvent extends Equatable {}

class FetchPengeluaranEvent extends PengeluaranEvent {
  FetchPengeluaranEvent();
  @override
  List<Object> get props => [];
}
class PengeluaranStoreEvent extends PengeluaranEvent {
  final Pengeluaran pengeluaran;

  PengeluaranStoreEvent({required this.pengeluaran});
  @override
  List<Object> get props => [];
}

class PengeluaranUpdateEvent extends PengeluaranEvent {
  final String id;
  final Pengeluaran pengeluaran;

  PengeluaranUpdateEvent({
    required this.id,
    required this.pengeluaran,
  });
  @override
  List<Object> get props => [];
}

class PengeluaranDeleteEvent extends PengeluaranEvent {
  final String id;

  PengeluaranDeleteEvent({
    required this.id,
  });
  @override
  List<Object> get props => [];
}
