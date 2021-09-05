import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kasir_mri/bloc/produk_bloc/ProdukEvent.dart';
import 'package:kasir_mri/bloc/produk_bloc/produk_state.dart';
import 'package:kasir_mri/repo/produk_repository.dart';

class ProdukBloc extends Bloc<ProdukEvent, ProdukState> {
  ProdukRepository repository;

  ProdukBloc(this.repository) : super(ProdukInitialState());
  ProdukInitialState get initialState => ProdukInitialState();

  @override
  Stream<ProdukState> mapEventToState(ProdukEvent event) async* {
    if (event is ProdukStoreEvent) {
      try {
        yield ProdukLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.produkStore(event.file, event.produk);
        yield ProdukSuccessState(data.responsemsg);
      } catch (e) {
        yield ProdukErrorState(e.toString());
      }
    } else if (event is ProdukUpdateEvent) {
      print("ProdukUpdateEvent ");
      try {
        yield ProdukLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.produkUpdate(event.file, event.id, event.produk);
        yield ProdukSuccessState(data.responsemsg);
      } catch (e) {
      print("ProdukUpdateEvent "+e.toString());
        yield ProdukErrorState(e.toString());
      }
    }else if (event is FetchProdukEvent) {
      print("FetchProdukEvent ");
      try {
        yield ProdukLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.fetchProduks();
        yield ProdukLoadedState(data.produk);
      } catch (e) {
      print("ProdukUpdateEvent "+e.toString());
        yield ProdukErrorState(e.toString());
      }
    }else if (event is ProdukDeleteEvent) {
      print("ProdukDeleteEvent ");
      try {
        yield ProdukLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.produkDelete(event.id);
        yield ProdukSuccessState(data.responsemsg);
      } catch (e) {
      print("ProdukDeleteEvent "+e.toString());
        yield ProdukErrorState(e.toString());
      }
    }else if (event is FetchProdukEventByIdKategori) {
      print("FetchProdukEventByIdKategori ");
      try {
        yield ProdukLoadingState();
        await Future.delayed(const Duration(milliseconds: 30));
        final data = await repository.fetchProduksByIdKategori(event.id);
        yield ProdukLoadedState(data.produk);
      } catch (e) {
        print("FetchProdukEventByIdKategori "+e.toString());
        yield ProdukErrorState(e.toString());
      }
    }
  }
}
