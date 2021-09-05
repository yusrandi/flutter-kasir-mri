import 'package:equatable/equatable.dart';

abstract class KategoriEvent extends Equatable{}
class FetchKategoriEvent extends KategoriEvent {
  FetchKategoriEvent();
  @override
  List<Object> get props => [];
}

class KategoriStoreEvent extends KategoriEvent {
  final String name;
  KategoriStoreEvent({required this.name});
  @override
  List<Object> get props => [];
}

class KategoriUpdateEvent extends KategoriEvent {
  final int id;
  final String name;

  KategoriUpdateEvent({required this.id, required this.name});

  @override
  List<Object> get props => [];
}

class KategoriDeleteEvent extends KategoriEvent {
  final int id;
  final String name;

  KategoriDeleteEvent({required this.id, required this.name});

  @override
  List<Object> get props => [];
}



