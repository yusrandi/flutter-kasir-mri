import 'package:equatable/equatable.dart';

abstract class AbsensiState extends Equatable{}

class AbsensiInitialState extends AbsensiState{

  @override
  List<Object?> get props => [];

}

class AbsensiLoadingState extends AbsensiState{
  @override
  List<Object?> get props => [];
}

class AbsensiSuccessState extends AbsensiState{
  final String msg;
  AbsensiSuccessState(this.msg);
  @override
  List<Object?> get props => [];

}

class AbsensiErrorState extends AbsensiState{
  final String msg;
  AbsensiErrorState(this.msg);
  @override
  List<Object?> get props => [];

}