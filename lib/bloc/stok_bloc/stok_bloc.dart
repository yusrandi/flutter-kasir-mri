
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/stok_bloc/stok_event.dart';
import 'package:kasir_mri/bloc/stok_bloc/stok_state.dart';
import 'package:kasir_mri/repo/stok_repository.dart';

class StokBloc extends Bloc<StokEvent, StokState>{
  StokRepository repository;

  StokBloc(this.repository) : super(StokInitialState());
  StokInitialState get initialState => StokInitialState();

  @override
  Stream<StokState> mapEventToState(StokEvent event) async* {

    if (event is FetchStokEvent){
      try{
        yield StokLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.fetchStoks();
        yield StokLoadedState(data.stok);
      }catch(e){
        yield StokErrorState(e.toString());
      }
    }else if (event is StokStoreEvent){
      try{
        yield StokLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.StokStore(event.stok);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield StokSuccessState(data.responsemsg);
        } else {
          yield StokErrorState(data.responsemsg);
        }
      }catch(e){
        yield StokErrorState(e.toString());
      }
    }else if (event is StokUpdateEvent){
      try{
        yield StokLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.StokUpdate(event.id, event.stok);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield StokSuccessState(data.responsemsg);
        } else {
          yield StokErrorState(data.responsemsg);
        }
      }catch(e){
        yield StokErrorState(e.toString());
      }
    }else if (event is StokDeleteEvent){
      try{
        yield StokLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.StokDelete(event.id);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield StokSuccessState(data.responsemsg);
        } else {
          yield StokErrorState(data.responsemsg);
        }
      }catch(e){
        yield StokErrorState(e.toString());
      }
    }
  }



}