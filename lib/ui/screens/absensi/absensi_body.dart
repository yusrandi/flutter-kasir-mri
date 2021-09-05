import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:kasir_mri/bloc/absensi_bloc/absensi_bloc.dart';
import 'package:kasir_mri/bloc/absensi_bloc/absensi_state.dart';
import 'package:kasir_mri/bloc/absensi_bloc/produk_event.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_bloc.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_event.dart';
import 'package:kasir_mri/bloc/pegawai_bloc/pegawai_state.dart';
import 'package:kasir_mri/models/absensi_model.dart';
import 'package:kasir_mri/models/pegawai_model.dart';
import 'package:kasir_mri/res/images.dart';
import 'package:kasir_mri/res/styling.dart';

class AbsensiBody extends StatefulWidget {
  const AbsensiBody({Key? key}) : super(key: key);

  @override
  _AbsensiBodyState createState() => _AbsensiBodyState();
}

class _AbsensiBodyState extends State<AbsensiBody> {
  File? _imageFile;
  late File? resFile;
  final ImagePicker _picker = ImagePicker();

  int pegawaiDropdownValue = 0;
  String hadirDropdownValue = "masuk";

  late PegawaiBloc pegawaiBloc;
  late AbsensiBloc absensiBloc;

  List<Pegawai> listPegawai = [];

  String resTgl = "";
  int resIdPegawai = 0;
  String resStatusHadir = "masuk";

  @override
  void initState() {
    super.initState();
    pegawaiBloc = BlocProvider.of<PegawaiBloc>(context);
    absensiBloc = BlocProvider.of<AbsensiBloc>(context);

    pegawaiBloc.add(FetchPegawaiEvent());
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    String formattedDate =
        DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
    resTgl = formattedDate;

    return BlocListener<AbsensiBloc, AbsensiState>(
      listener: (context, state) {
        print(state);
        if (state is AbsensiInitialState || state is AbsensiLoadingState) {
          EasyLoading.show(status: 'loading...');
        } else if (state is AbsensiErrorState) {
          EasyLoading.showError(state.msg);
        } else if (state is AbsensiSuccessState) {
          EasyLoading.showSuccess(state.msg);
          Navigator.pop(context);
        }
      },
      child: Container(
        padding: EdgeInsets.all(16),
        height: size.height,
        width: size.width,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(resTgl, style: TextStyle(color: Colors.grey, fontSize: 20)),
              SizedBox(height: 16),
              Container(
                child: Stack(
                  children: [
                    Container(
                      height: 250,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: AppTheme.hintTextColor,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: _imageFile == null
                            ? Image.asset(Images.imagePlaceholderProduk)
                            : Image.file(File(_imageFile!.path)),
                      ),
                    ),
                    Positioned(
                        right: 0,
                        bottom: 0,
                        child: InkWell(
                          onTap: () {
                            _takePhotos(ImageSource.camera);
                          },
                          child: Icon(
                            Icons.camera_alt,
                            size: 50,
                            color: Colors.black,
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Text("Silahkan Pilih Nama Anda",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: 8),
              loadPegawai(),
              SizedBox(height: 16),
              Text("Silahkan Status Kehadiran",
                  style: TextStyle(color: Colors.grey, fontSize: 16)),
              SizedBox(height: 8),
              buildKehadiran(),
              SizedBox(height: 32),
              GestureDetector(
                onTap: () {
                  if (resIdPegawai != 0) {
                    EasyLoading.showSuccess('Great Success!');

                    absensiBloc.add(AbsensiStoreEvent(
                        file: resFile,
                        absensi: Absensi(
                            id: 0,
                            foto: "foto",
                            tanggal: resTgl,
                            status: resStatusHadir,
                            pegawaiId: resIdPegawai)));
                  } else {
                    EasyLoading.showToast("pilih namata dulu");
                  }
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: <Color>[
                            AppTheme.selectedTabBackgroundColor,
                            Colors.orange
                          ])),
                  child: Center(
                      child: Text("Submit",
                          style: Theme.of(context).primaryTextTheme.headline6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget loadPegawai() {
    return BlocBuilder<PegawaiBloc, PegawaiState>(builder: (context, state) {
      print(state);
      if (state is PegawaiInitialState || state is PegawaiLoadingState) {
        return buildLoading();
      } else if (state is PegawaiLoadedState) {
        listPegawai = [];
        listPegawai.add(Pegawai(
            id: 0,
            kategoriPegawai: "",
            nama: "Pilih Pegawai",
            hp: "",
            email: "",
            password: ""));

        listPegawai.addAll(state.pegawais);
        return buildPegawai(listPegawai);
      } else {
        return buildLoading();
      }
    });
  }

  Container buildPegawai(List<Pegawai> list) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border:
              Border.all(color: AppTheme.selectedTabBackgroundColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<int>(
        value: pegawaiDropdownValue,
        hint: Text("Pilih Sapi"),
        items: list.map((Pegawai value) {
          return DropdownMenuItem<int>(
            value: value.id,
            child: new Text(value.nama),
          );
        }).toList(),
        onChanged: (newValue) {
          print(newValue);

          setState(() {
            pegawaiDropdownValue = newValue!;
            resIdPegawai = newValue;
          });
        },
      ),
    );
  }

  Container buildKehadiran() {
    List<String> listHadir = ['masuk', 'keluar'];
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
          border:
              Border.all(color: AppTheme.selectedTabBackgroundColor, width: 1),
          borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: DropdownButton<String>(
        value: hadirDropdownValue,
        hint: Text("Pilih Status Kehadiran"),
        items: listHadir.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: new Text(value),
          );
        }).toList(),
        onChanged: (newValue) {
          print(newValue);
          setState(() {
            hadirDropdownValue = newValue!;
            resStatusHadir = newValue;
          });
        },
      ),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _takePhotos(ImageSource source) async {
    final pickedFile = await _picker.getImage(source: source);
    if (pickedFile != null) {
      File? cropped = await ImageCropper.cropImage(
          sourcePath: pickedFile.path,
          aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
          compressQuality: 70,
          compressFormat: ImageCompressFormat.jpg);

      setState(() {
        _imageFile = cropped!;
        resFile = _imageFile!;
      });
    }
  }

  Future pickDate(BuildContext context) async {
    final initialDate = DateTime.now();
    final newDate = await showDatePicker(
        context: context,
        initialDate: initialDate,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5));

    if (newDate == null) return;

    setState(() {
      resTgl = DateFormat('yyyy/MM/dd').format(newDate);
    });
  }
}
