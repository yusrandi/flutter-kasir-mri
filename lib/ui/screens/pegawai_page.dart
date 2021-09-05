import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_bloc.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_event.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_state.dart';
import 'package:kasir_mri/models/pegawai_model.dart';
import 'package:kasir_mri/repo/pegawai_repository.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/res/styling.dart';
import 'package:kasir_mri/ui/screens/widgets/danger_button.dart';
import 'package:kasir_mri/ui/screens/widgets/input_with_icon.dart';
import 'package:kasir_mri/ui/screens/widgets/primary_button.dart';

class PegawaiLandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PegawaiBloc(PegawaiRepositoryImpl()),
      child: PegawaiPage(),
    );
  }
}

class PegawaiPage extends StatefulWidget {
  @override
  _PegawaiPageState createState() => _PegawaiPageState();
}

class _PegawaiPageState extends State<PegawaiPage> {
  late PegawaiBloc _bloc;
  final _name = new TextEditingController();
  final _hp = new TextEditingController();
  final _email = new TextEditingController();
  final _password = new TextEditingController();

  double _loginYOffset = 0.0;
  double _loginHeight = 0;
  double _loginOpacity = 0;
  double _homeOpacity = 1;

  bool keyboardVisibility = false;

  int _pageState = 0;

  List<String> items = ['Kategori Pegawai', 'Kasir', 'Pegawai', 'Supervisor'];

  String dropdownValue = "Kategori Pegawai";

  String resId = "";

  @override
  void initState() {
    _bloc = BlocProvider.of<PegawaiBloc>(context);
    _bloc.add(FetchPegawaiEvent());

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
        title: Text("Pegawai"),
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
        height: size.height,
        width: size.width,
        child: Stack(children: [
          Container(
              height: 250,
              color: Colors.white.withOpacity(_homeOpacity),
              child: _loadPegawai()),
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
              ))
        ]));
  }

  Widget _loadPegawai() {
    return BlocListener<PegawaiBloc, PegawaiState>(
      listener: (context, state) {
        if (state is PegawaiErrorState) {
          EasyLoading.showError(state.msg);
          _bloc.add(FetchPegawaiEvent());
        } else if (state is PegawaiSuccessState) {
          EasyLoading.showSuccess(state.msg);
          _bloc.add(FetchPegawaiEvent());
        }
      },
      child: BlocBuilder<PegawaiBloc, PegawaiState>(
        builder: (context, state) {
          print("state $state");

          if (state is PegawaiInitialState || state is PegawaiLoadingState) {
            return _buildLoading();
          } else if (state is PegawaiLoadedState) {
            return _builPegawai(state.pegawais);
          } else {
            return _buildLoading();
          }
        },
      ),
    );
  }

  Widget _builPegawai(List<Pegawai> pegawais) {
    return ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: pegawais.length,
        itemBuilder: (context, index) {
          var pegawai = pegawais[index];
          return Container(
            height: 150,
            width: 150,
            margin: EdgeInsets.only(right: 8),
            child: Stack(
              children: [
                Positioned(
                    top: 50,
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      padding: EdgeInsets.only(top: 100),
                      decoration: BoxDecoration(
                        color: pegawai.kategoriPegawai == "Kasir"
                            ? Colors.orange[50]
                            : pegawai.kategoriPegawai == "Pegawai"
                                ? Colors.blue[50]
                                : Colors.red[50],
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        children: [
                          Text(pegawai.nama,
                              style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                          Text(pegawai.kategoriPegawai,
                              style: TextStyle(
                                  color: Colors.orange, fontSize: 12)),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _pageState = 1;
                                  });
                                  resId = pegawai.id.toString();
                                  dropdownValue = pegawai.kategoriPegawai;
                                  _name.text = pegawai.nama;
                                  _hp.text = pegawai.hp;
                                  _email.text = pegawai.email;
                                  _password.text = "";
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color:
                                          AppTheme.selectedTabBackgroundColor),
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
                                  _alertConfirm(pegawai.id.toString());
                                },
                                child: Container(
                                  height: 30,
                                  width: 30,
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
                        ],
                      ),
                    )),
                Positioned(
                    top: 0,
                    right: 0,
                    left: 0,
                    child: Image(
                      image: AssetImage(Images.employeeImage),
                    )),
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
              "Tambah Pegawai",
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          _dropDownItems(items),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Nama Pegawai",
            icon: FontAwesomeIcons.user,
            controller: _name,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Nomor Hp",
            icon: Icons.phone,
            controller: _hp,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Email",
            icon: Icons.email,
            controller: _email,
          ),
          SizedBox(height: 16),
          InputWithIcon(
            inputText: "Silahkan Masukkan Password",
            icon: FontAwesomeIcons.key,
            controller: _password,
          ),
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
                      
                      var nama = _name.text.trim();
                      var hp = _hp.text.trim();
                      var email = _email.text.trim();
                      var pass = _password.text.trim();

                      if (nama.isNotEmpty &&
                          hp.isNotEmpty &&
                          email.isNotEmpty ) {
                        var pegawai = Pegawai(
                            id: resId == "" ? 0 : int.parse(resId),
                            kategoriPegawai: dropdownValue,
                            nama: nama,
                            hp: hp,
                            email: email,
                            password: pass);

                        resId == ""
                            ? _bloc.add(PegawaiStoreEvent(pegawai: pegawai))
                            : _bloc.add(PegawaiUpdateEvent(
                                id: resId, pegawai: pegawai));
                        clearField();
                        setState(() {
                          _pageState = 0;
                        });
                      } else {
                        EasyLoading.showError("harap mengisi semua kolom");
                      }
                    },
                    child: PrimaryButton(btnText: "Submit")),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _dropDownItems(List<String> items) {
    return Container(
        decoration: BoxDecoration(
            border: Border.all(color: AppTheme.hintTextColor, width: 1),
            borderRadius: BorderRadius.circular(10)),
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: DropdownButton<String>(
          value: dropdownValue,
          elevation: 16,
          onChanged: (String? newValue) {
            setState(() {
              dropdownValue = newValue!;
            });
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ));
  }

  void clearField() {
    dropdownValue = "Kategori Pegawai";
    _name.text = "";
    _hp.text = "";
    _email.text = "";
    _password.text = "";
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
      _bloc.add(PegawaiDeleteEvent(id: id));
      return;
    }
  }

  Widget _buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}
