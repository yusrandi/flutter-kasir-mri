import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_bloc.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_event.dart';
import 'package:kasir_mri/bloc/transaksi_bloc/transaksi_state.dart';
import 'package:kasir_mri/models/transaksi_model.dart';
import 'package:kasir_mri/repo/transaksi_repo.dart';
import 'package:kasir_mri/res/styling.dart';

class TransaksiLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransaksiBloc(TransaksiRepositoryImpl()),
      child: TransaksiPage(),
    );
  }
}

class TransaksiPage extends StatefulWidget {
  @override
  _TransaksiPageState createState() => _TransaksiPageState();
}

class _TransaksiPageState extends State<TransaksiPage> {
  late TransaksiBloc _bloc;
  DateTimeRange? dateTimeRange;

  String getFrom() {
    if (dateTimeRange == null) {
      return 'From';
    } else {
      return DateFormat('yyyy/MM/dd').format(dateTimeRange!.start);
    }
  }

  String getUntill() {
    if (dateTimeRange == null) {
      return 'Until';
    } else {
      return DateFormat('yyyy/MM/dd').format(dateTimeRange!.end);
    }
  }

  @override
  void initState() {
    _bloc = BlocProvider.of<TransaksiBloc>(context);
    _bloc.add(FetchTransaksiEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Transaksi"),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                AppTheme.selectedTabBackgroundColor,
                Colors.yellow
              ])),
        ),
      ),
      body: _pageBody(context),
    );
  }

  Widget _pageBody(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Container(
              padding: EdgeInsets.all(16),
              margin: EdgeInsets.only(bottom: 100),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Silahkan Pilih Tanggal',
                      style: TextStyle(fontSize: 18, fontFamily: 'nunito'),
                      textAlign: TextAlign.start),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      pickDateRange(context);
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(getFrom(), style: TextStyle(fontSize: 16)),
                          Icon(FontAwesomeIcons.arrowsAltH),
                          Text(getUntill(), style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                  _loadTransaksi(),
                ],
              ),
            ),
          ),
        ),
      ],
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
            return _buildTransaksi(state.transaksis, state.pengeluaran);
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

  Widget _buildTransaksi(List<Transaksi> items, int pengeluaran) {
    int total = 0;
    items.forEach((element) => total += element.total);

    int pendapatan = total - pengeluaran;

    if (items.length == 0) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Text("Transaksi not Found"),
        ),
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
              Text('Total Pemasukan',
                  style: Theme.of(context).textTheme.bodyText2),
              Text("Rp. " + NumberFormat("#,##0", "en_US").format(total),
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Pengeluaran',
                  style: Theme.of(context).textTheme.bodyText2),
              Text("Rp. " + NumberFormat("#,##0", "en_US").format(pengeluaran),
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
        
        Container(
          margin: EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total Pendapatan',
                  style: Theme.of(context).textTheme.bodyText2),
              Text("Rp. " + NumberFormat("#,##0", "en_US").format(pendapatan),
                  style: Theme.of(context).textTheme.headline6),
            ],
          ),
        ),
      ],
    );
  }

  Future pickDateRange(BuildContext context) async {
    final initialDateRange = DateTimeRange(
        start: DateTime.now(),
        end: DateTime.now().add(Duration(hours: 24 * 3)));
    final newDateRange = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange: dateTimeRange ?? initialDateRange);

    if (newDateRange == null) return null;
    setState(() {
      dateTimeRange = newDateRange;
      _bloc.add(FetchTransaksiByDateEvent(
          startDate: getFrom(), endDate: getUntill()));
    });
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
