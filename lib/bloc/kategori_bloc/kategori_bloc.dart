
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_event.dart';
import 'package:kasir_mri/bloc/kategori_bloc/kategori_state.dart';
import 'package:kasir_mri/repo/kategori_repository.dart';

class KategoriBloc extends Bloc<KategoriEvent, KategoriState>{
  KategoriRepository repository;

  KategoriBloc(this.repository) : super(KategoriInitialState());
  KategoriInitialState get initialState => KategoriInitialState();

  @override
  Stream<KategoriState> mapEventToState(KategoriEvent event) async* {

    if (event is FetchKategoriEvent){
      try{
        yield KategoriLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.fetchKategoris();
        yield KategoriLoadedState(data.kategori);
      }catch(e){
        yield KategoriErrorState(e.toString());
      }
    }else if (event is KategoriStoreEvent){
      try{
        yield KategoriLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.kategoriStore(event.name);
        yield KategoriSuccessState(data.responsemsg);
      }catch(e){
        yield KategoriErrorState(e.toString());
      }
    }else if (event is KategoriUpdateEvent){
      try{
        yield KategoriLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.kategoriUpdate(event.id, event.name);
        yield KategoriSuccessState(data.responsemsg);
      }catch(e){
        yield KategoriErrorState(e.toString());
      }
    }else if (event is KategoriDeleteEvent){
      try{
        yield KategoriLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.kategoriDelete(event.id, event.name);
        yield KategoriSuccessState(data.responsemsg);
      }catch(e){
        yield KategoriErrorState(e.toString());
      }
    }
  }



}