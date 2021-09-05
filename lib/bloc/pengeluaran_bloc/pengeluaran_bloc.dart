
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/pengeluaran_bloc/pengeluaran_event.dart';
import 'package:kasir_mri/bloc/pengeluaran_bloc/pengeluaran_state.dart';
import 'package:kasir_mri/repo/pengeluaran_repository.dart';

class PengeluaranBloc extends Bloc<PengeluaranEvent, PengeluaranState>{
  PengeluaranRepository repository;

  PengeluaranBloc(this.repository) : super(PengeluaranInitialState());
  PengeluaranInitialState get initialState => PengeluaranInitialState();

  @override
  Stream<PengeluaranState> mapEventToState(PengeluaranEvent event) async* {

    if (event is FetchPengeluaranEvent){
      try{
        yield PengeluaranLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.fetchPengeluarans();
        yield PengeluaranLoadedState(data.pengeluaran);
      }catch(e){
        yield PengeluaranErrorState(e.toString());
      }
    }else if (event is PengeluaranStoreEvent){
      try{
        yield PengeluaranLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.PengeluaranStore(event.pengeluaran);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield PengeluaranSuccessState(data.responsemsg);
        } else {
          yield PengeluaranErrorState(data.responsemsg);
        }
      }catch(e){
        yield PengeluaranErrorState(e.toString());
      }
    }else if (event is PengeluaranUpdateEvent){
      try{
        yield PengeluaranLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.PengeluaranUpdate(event.id, event.pengeluaran);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield PengeluaranSuccessState(data.responsemsg);
        } else {
          yield PengeluaranErrorState(data.responsemsg);
        }
      }catch(e){
        yield PengeluaranErrorState(e.toString());
      }
    }else if (event is PengeluaranDeleteEvent){
      try{
        yield PengeluaranLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.PengeluaranDelete(event.id);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield PengeluaranSuccessState(data.responsemsg);
        } else {
          yield PengeluaranErrorState(data.responsemsg);
        }
      }catch(e){
        yield PengeluaranErrorState(e.toString());
      }
    }
  }



}