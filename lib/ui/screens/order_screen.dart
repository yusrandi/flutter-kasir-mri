import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_bloc.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_event.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_state.dart';
import 'package:kasir_mri/models/transaksi_model.dart';
import 'package:kasir_mri/repo/transaksi_repo.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/res/styling.dart';

class OrderLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransaksiBloc(TransaksiRepositoryImpl()),
      child: OrderPage(),
    );
  }
}

class OrderPage extends StatefulWidget {
  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late TransaksiBloc _bloc;

  List<Transaksi> itemsOrderan = [];
  int total = 0;

  @override
  void initState() {
    _bloc = BlocProvider.of<TransaksiBloc>(context);
    _bloc.add(FetchTransaksiByDateEvent(
        startDate: DateFormat('yyyy/MM/dd').format(DateTime.now().toLocal()),
        endDate: DateFormat('yyyy/MM/dd').format(DateTime.now().toLocal())));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              width: size.width,
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  AppTheme.selectedTabBackgroundColor,
                  Colors.yellowAccent,
                ]),
              ),
              child: Stack(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(16, 40, 0, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                            child: RichText(
                                text: TextSpan(children: [
                          TextSpan(
                              text: "Good Morning\n\n",
                              style: TextStyle(
                                  fontSize: 26, fontWeight: FontWeight.bold)),
                          TextSpan(
                              text:
                                  'how are u today manager,\n thx God to see u again',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold)),
                        ]))),
                        Image.asset(Images.homeImage),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              top: 100,
              child: Container(
                width: size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(25))),
                child: Padding(
                  padding: EdgeInsets.all(16),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Orderan Hari Ini ',
                            style: Theme.of(context).textTheme.headline6),
                        // SizedBox(height: 8),
                        _loadTransaksi(),
                      ],
                    ),
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _loadTransaksi() {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listener: (context, state) {
        if (state is TransaksiErrorState) {
          _alertError(state.msg);
        } else if (state is TransaksiSuccessState) {
          _alertSuccess();
          _bloc.add(FetchTransaksiEvent());
        }
      },
      child: BlocBuilder<TransaksiBloc, TransaksiState>(
        builder: (context, state) {
          print("state $state");
          if (state is TransaksiLoadedState) {
            return _buildTransaksi(state.transaksis);
          } else if (state is TransaksiInitialState ||
              state is TransaksiLoadingState) {
            return _buildLoading();
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _buildTransaksi(List<Transaksi> items) {
    int total = 0;
    items.forEach((element) => total += element.total);

    if (items.length == 0) {
      return Center(
        child: Text("Orderan Belum Ada"),
      );
    }
    return Column(
      children: [
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
                child: DataTable(
              columnSpacing: 10,
              columns: [
                DataColumn(
                    label: Text("NO",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("Tanggal",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("Kode Transaksi",
                        style: Theme.of(context).textTheme.subtitle1)),
                DataColumn(
                    label: Text("Total",
                        style: Theme.of(context).textTheme.subtitle1)),
              ],
              rows: items
                  .map((e) => DataRow(cells: [
                        DataCell(Text((items.indexOf(e) + 1).toString(),
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(e.tanggal,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(e.kodeTransaksi,
                            style: Theme.of(context).textTheme.caption)),
                        DataCell(Text(
                            "Rp. " +
                                NumberFormat("#,##0", "en_US")
                                    .format(int.parse(e.total.toString())),
                            style: Theme.of(context).textTheme.caption)),
                      ]))
                  .toList(),
            ))),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total ', style: Theme.of(context).textTheme.headline6),
              Text("Rp. " + NumberFormat("#,##0", "en_US").format(total),
                  style: Theme.of(context).textTheme.headline4),
            ],
          ),
        ),
      ],
    );
  }

  void _alertSuccess() {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs:
            ArtDialogArgs(type: ArtSweetAlertType.success, title: "Saved!"));
  }

  void _alertError(String msg) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger,
            title: "Oops...",
            text: "There is a problem :("));
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
