import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_event.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_state.dart';
import 'package:kasir_mri/repo/transaksi_repo.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  TransaksiRepository repository;

  TransaksiBloc(this.repository) : super(TransaksiInitialState());

  TransaksiInitialState get initialState => TransaksiInitialState();

  @override
  Stream<TransaksiState> mapEventToState(TransaksiEvent event)  async*{

    if (event is FetchTransaksiEvent){
      try{
        yield TransaksiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.transaksiFetch();
        yield TransaksiLoadedState(data.transaksi, data.pengeluaran);
      }catch(e){
        yield TransaksiErrorState(e.toString());
      }
    }else if (event is FetchTransaksiByDateEvent){
      try{
        yield TransaksiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.transaksiFetchByDate(event.startDate, event.endDate);
        yield TransaksiLoadedState(data.transaksi, data.pengeluaran);
      }catch(e){
        yield TransaksiErrorState(e.toString());
      }
    }else if (event is TransaksiStoreEvent){
      try{
        yield TransaksiLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.transaksiStore(event.total, event.productId, event.qty);
        // ignore: unrelated_type_equality_checks
        if (data.responsecode == "1") {
          yield TransaksiSuccessState(data.responsemsg);
        } else {
          yield TransaksiErrorState(data.responsemsg);
        }
      }catch(e){
        yield TransaksiErrorState(e.toString());
      }
    }
  }
}
