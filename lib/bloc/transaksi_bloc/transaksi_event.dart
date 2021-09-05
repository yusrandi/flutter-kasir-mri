import 'package:equatable/equatable.dart';

abstract class TransaksiEvent extends Equatable {}

class FetchTransaksiEvent extends TransaksiEvent {
  FetchTransaksiEvent();
  @override
  List<Object> get props => [];
}

class FetchTransaksiByDateEvent extends TransaksiEvent {
  final String startDate, endDate;

  FetchTransaksiByDateEvent({required this.startDate, required this.endDate});
  @override
  List<Object> get props => [];
}

class TransaksiStoreEvent extends TransaksiEvent {
  final String total;
  final String productId, qty;

  TransaksiStoreEvent({required this.total, required this.productId, required this.qty});
  @override
  List<Object> get props => [];
}
