import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kasir_mri/bloc/pengeluaran_bloc/pengeluaran_bloc.dart';
import 'package:kasir_mri/bloc/pengeluaran_bloc/pengeluaran_event.dart';
import 'package:kasir_mri/bloc/pengeluaran_bloc/pengeluaran_state.dart';
import 'package:kasir_mri/models/pengeluaran_modal.dart';
import 'package:kasir_mri/repo/pengeluaran_repository.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mri/ui/screens/widgets/danger_button.dart';
import 'package:kasir_mri/ui/screens/widgets/input_with_icon.dart';
import 'package:kasir_mri/ui/screens/widgets/primary_button.dart';

class PengeluaranLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PengeluaranBloc(PengeluaranRepositoryImpl()),
      child: PengeluaranPage(),
    );
  }
}

class PengeluaranPage extends StatefulWidget {
  @override
  _PengeluaranPageState createState() => _PengeluaranPageState();
}

class _PengeluaranPageState extends State<PengeluaranPage> {
  late PengeluaranBloc _bloc;

  final _kategori = new TextEditingController();
  final _sumber = new TextEditingController();
  final _jumlah = new TextEditingController();
  final _catatan = new TextEditingController();

  double _loginYOffset = 0.0;
  double _loginHeight = 0;
  double _loginOpacity = 0;
  double _homeOpacity = 1;

  bool keyboardVisibility = false;

  int _pageState = 0;

  String resId = "";

  @override
  void initState() {
    _bloc = BlocProvider.of<PengeluaranBloc>(context);
    _bloc.add(FetchPengeluaranEvent());

    var keyboardVisibilityController = KeyboardVisibilityController();
    // Query
    print(
        'Keyboard visibility direct query: ${keyboardVisibilityController.isVisible}');

    // Subscribe
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('Keyboard visibility update. Is visible: ${visible}');
      keyboardVisibility = visible;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    _loginHeight = size.height - (size.height / 2);

    switch (_pageState) {
      case 0:
        print("_ProdukPageState $keyboardVisibility");
        _loginYOffset = size.height;
        _loginHeight =
            keyboardVisibility ? size.height : size.height - (size.height / 2);
        _loginOpacity = 1;
        _homeOpacity = 1;
        break;
      case 1:
        print("_ProdukPageState $keyboardVisibility");
        _loginYOffset = keyboardVisibility ? 50 : 50;
        _loginHeight = keyboardVisibility ? size.height : size.height;
        _loginOpacity = 1;
        _homeOpacity = 0;
        break;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Pengeluaran"),
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
      body: _pageBody(size),
    );
  }

  Widget _pageBody(Size size) {
    return Container(
        padding: EdgeInsets.all(8),
        height: size.height,
        width: size.width,
        child: Stack(children: [
          Container(
              height: size.height,
              color: Colors.white.withOpacity(_homeOpacity),
              child: _loadPengeluaran(size)),
          _formInput(size),
          Positioned(
              right: 16,
              bottom: 16,
              child: FloatingActionButton(
                backgroundColor: AppTheme.selectedTabBackgroundColor,
                onPressed: () {
                  setState(() {
                    _pageState = 1;
                  });
                },
                child: Icon(Icons.add),
              )),
        ]));
  }

  Widget _loadPengeluaran(Size size) {
    return BlocListener<PengeluaranBloc, PengeluaranState>(
      listener: (context, state) {
        if (state is PengeluaranErrorState) {
          EasyLoading.showError(state.msg);
          _bloc.add(FetchPengeluaranEvent());
        } else if (state is PengeluaranSuccessState) {
          EasyLoading.showSuccess(state.msg);
          _bloc.add(FetchPengeluaranEvent());
        }
      },
      child: BlocBuilder<PengeluaranBloc, PengeluaranState>(
        builder: (context, state) {
          print("state $state");

          if (state is PengeluaranInitialState ||
              state is PengeluaranLoadingState) {
            return _buildLoading();
          } else if (state is PengeluaranLoadedState) {
            return Container(
                height: size.height,
                width: size.width,
                child: _buildPengeluaran(state.pengeluarans));
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _buildPengeluaran(List<Pengeluaran> pengeluarans) {
    return ListView.builder(
        itemCount: pengeluarans.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          var pengeluaran = pengeluarans[index];
          return Container(
            height: 160,
            margin: EdgeInsets.only(bottom: 8),
            child: Stack(
              children: [
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? Colors.orange[50]
                            : Colors.lightBlue[50],
                        borderRadius: BorderRadius.circular(16)),
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  pengeluaran.kategori,
                                  style: TextStyle(
                                      fontSize: 18, fontFamily: "Nunito"),
                                ),
                              ),
                              Text(pengeluaran.sumber,
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: "Nunito")),
                              Text(pengeluaran.catatan,
                                  style: TextStyle(
                                      fontSize: 14, fontFamily: "Nunito")),
                            ],
                          ),
                          Column(children: [
                            Center(
                              child: RichText(
                                  textAlign: TextAlign.center,
                                  text: TextSpan(children: [
                                    TextSpan(
                                        text: "Jumlah\n",
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                        text: "Rp. " +
                                            NumberFormat("#,##0", "en_US")
                                                .format(int.parse(
                                                    pengeluaran.jumlah)),
                                        style: TextStyle(
                                            fontSize: 24,
                                            fontFamily: "Nunito",
                                            color: index % 2 == 0
                                                ? Colors.orange
                                                : Colors.lightBlue)),
                                  ])),
                            ),
                            SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _pageState = 1;
                                    });

                                    resId = pengeluaran.id.toString();
                                    _kategori.text = pengeluaran.kategori;
                                    _jumlah.text = pengeluaran.jumlah;
                                    _sumber.text = pengeluaran.sumber;
                                    _catatan.text = pengeluaran.catatan;
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppTheme
                                            .selectedTabBackgroundColor),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () {
                                    _alertConfirm(pengeluaran.id.toString());
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: AppTheme.redBackgroundColor),
                                    child: Icon(
                                      Icons.delete,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  Widget _formInput(Size size) {
    return AnimatedContainer(
      height: _loginHeight,
      width: size.width,
      padding: EdgeInsets.all(26),
      curve: Curves.fastLinearToSlowEaseIn,
      duration: Duration(milliseconds: 1000),
      transform: Matrix4.translationValues(0, _loginYOffset, 1),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(_loginOpacity),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(26),
            topRight: Radius.circular(26),
          )),
      child: ListView(
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 16),
            child: Text(
              "Tambah Pengeluaran",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          InputWithIcon(
            inputText: "Input Kategori Pengeluaran",
            icon: FontAwesomeIcons.atom,
            controller: _kategori,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Input Sumber Pengeluaran",
            icon: FontAwesomeIcons.apple,
            controller: _sumber,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Input Jumlah Pengeluaran",
            icon: FontAwesomeIcons.moneyBill,
            controller: _jumlah,
          ),
          SizedBox(height: 16),
          InputWithIcon(
              inputText: "Input Catatan Pengeluaran",
              icon: FontAwesomeIcons.moneyBill,
              controller: _catatan),
          SizedBox(height: 16),
          Row(
            children: [
              GestureDetector(
                  onTap: () {
                    setState(() {
                      _pageState = 0;
                      clearField();
                    });
                  },
                  child: DangerButton(btnText: "Cancel")),
              SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: GestureDetector(
                    onTap: () {
                      
                      var kategori = _kategori.text.trim();
                      var sumber = _sumber.text.trim();
                      var jumlah = _jumlah.text.trim();
                      var catatan = _catatan.text.trim();

                      if (kategori.isNotEmpty &&
                          sumber.isNotEmpty &&
                          jumlah.isNotEmpty &&
                          catatan.isNotEmpty) {
                        var pengeluaran = Pengeluaran(
                            id: resId == "" ? 0 : int.parse(resId),
                            kategori: kategori,
                            sumber: sumber,
                            jumlah: jumlah,
                            catatan: catatan);

                        resId == ""
                            ? _bloc.add(
                                PengeluaranStoreEvent(pengeluaran: pengeluaran))
                            : _bloc.add(PengeluaranUpdateEvent(
                                id: resId, pengeluaran: pengeluaran));
                        clearField();
                        setState(() {
                          _pageState = 0;
                        });
                      } else {
                        EasyLoading.showError("Harap Mengisi Semua Kolom");
                      }
                    },
                    child: PrimaryButton(btnText: "Submit")),
              ),
            ],
          ),
          SizedBox(height: 16),
        ],
      ),
    );
  }

  void clearField() {
    resId = "";
    _kategori.text = "";
    _sumber.text = "";
    _jumlah.text = "";
    _catatan.text = "";
    keyboardVisibility = false;
  }

  void _alertSuccess(String msg) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs:
            ArtDialogArgs(type: ArtSweetAlertType.success, title: msg));
  }

  void _alertError(String msg) {
    ArtSweetAlert.show(
        context: context,
        artDialogArgs: ArtDialogArgs(
            type: ArtSweetAlertType.danger, title: "Oops...", text: msg));
  }

  void _alertConfirm(String id) async {
    ArtDialogResponse response = await ArtSweetAlert.show(
        barrierDismissible: false,
        context: context,
        artDialogArgs: ArtDialogArgs(
            denyButtonText: "Cancel",
            title: "Are you sure?",
            text: "You won't be able to revert this!",
            confirmButtonText: "Yes",
            type: ArtSweetAlertType.warning));

    if (response == null) {
      return;
    }

    if (response.isTapConfirmButton) {
      _bloc.add(PengeluaranDeleteEvent(id: id));
      return;
    }
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
