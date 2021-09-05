
import 'package:equatable/equatable.dart';
import 'package:kasir_mri/models/stok_model.dart';

abstract class StokEvent extends Equatable {}

class FetchStokEvent extends StokEvent {
  FetchStokEvent();
  @override
  List<Object> get props => [];
}
class StokStoreEvent extends StokEvent {
  final Stok stok;

  StokStoreEvent({required this.stok});
  @override
  List<Object> get props => [];
}

class StokUpdateEvent extends StokEvent {
  final String id;
  final Stok stok;

  StokUpdateEvent({
    required this.id,
    required this.stok,
  });
  @override
  List<Object> get props => [];
}

class StokDeleteEvent extends StokEvent {
  final String id;

  StokDeleteEvent({
    required this.id,
  });
  @override
  List<Object> get props => [];
}
