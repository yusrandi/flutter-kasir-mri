
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_event.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_state.dart';
import 'package:kasir_mri/repo/pegawai_repository.dart';

class PegawaiBloc extends Bloc<PegawaiEvent, PegawaiState>{
  PegawaiRepository repository;

  PegawaiBloc(this.repository) : super(PegawaiInitialState());
  PegawaiInitialState get initialState => PegawaiInitialState();

  @override
  Stream<PegawaiState> mapEventToState(PegawaiEvent event) async* {

    if (event is FetchPegawaiEvent){
      try{
        yield PegawaiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.fetchPegawais();
        yield PegawaiLoadedState(data.pegawai);
      }catch(e){
        yield PegawaiErrorState(e.toString());
      }
    }else if (event is PegawaiStoreEvent){
      try{
        yield PegawaiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.PegawaiStore(event.pegawai);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield PegawaiSuccessState(data.responsemsg);
        } else {
          yield PegawaiErrorState(data.responsemsg);
        }
      }catch(e){
        yield PegawaiErrorState(e.toString());
      }
    }else if (event is PegawaiUpdateEvent){
      try{
        yield PegawaiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.PegawaiUpdate(event.id, event.pegawai);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield PegawaiSuccessState(data.responsemsg);
        } else {
          yield PegawaiErrorState(data.responsemsg);
        }
      }catch(e){
        yield PegawaiErrorState(e.toString());
      }
    }else if (event is PegawaiDeleteEvent){
      try{
        yield PegawaiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.PegawaiDelete(event.id);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield PegawaiSuccessState(data.responsemsg);
        } else {
          yield PegawaiErrorState(data.responsemsg);
        }
      }catch(e){
        yield PegawaiErrorState(e.toString());
      }
    }
  }



}