import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/absensi_bloc/absensi_state.dart';
import 'package:kasir_mri/bloc/absensi_bloc/produk_event.dart';
import 'package:kasir_mri/repo/absensi_repo.dart';

class AbsensiBloc extends Bloc<AbsensiEvent, AbsensiState> {
  AbsensiRepository repository;

  AbsensiBloc(this.repository) : super(AbsensiInitialState());
  AbsensiInitialState get initialState => AbsensiInitialState();

  @override
  Stream<AbsensiState> mapEventToState(AbsensiEvent event) async* {
    if (event is AbsensiStoreEvent) {
      try {
        yield AbsensiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.absensiStore(event.file, event.absensi);
        
        yield AbsensiSuccessState(data.responsemsg);
        
      } catch (e) {
        yield AbsensiErrorState(e.toString());
      }
    } 
  }
}
