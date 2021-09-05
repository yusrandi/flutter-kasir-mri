import 'dart:convert';
import 'dart:io';

import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/absensi_model.dart';
import 'package:kasir_mri/models/response_model.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';


abstract class AbsensiRepository {
  Future<AbsensiModel> absensiFetchData();
  Future<ResponseModel> absensiStore(File? file, Absensi absensi);
}

class AbsensiRepositoryImpl implements AbsensiRepository {
  static const String TAG = "AbsensiRepositoryImpl";

  @override
  Future<AbsensiModel> absensiFetchData() async{
    var _response = await http.get(Uri.parse(Api.instance.absensiURL));
    print("$TAG, absensiFetchData ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG absensiFetchData true ");
      var data = json.decode(_response.body);
      print("Data $data");
      AbsensiModel model = AbsensiModel.fromJson(data);
      return model;
    } else {
      print("$TAG absensiFetchData else");
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> absensiStore(File? file, Absensi absensi) async{
    var request =
        new http.MultipartRequest("POST", Uri.parse(Api.instance.absensiURL));

    request.fields['pegawaiId'] = absensi.pegawaiId.toString();
    request.fields['foto'] = absensi.foto;
    request.fields['tanggal'] = absensi.tanggal;
    request.fields['status'] = absensi.status;

    if (file != null) {
      final resFile = await http.MultipartFile.fromPath('image', file.path,
          contentType: new MediaType('application', 'x-tar'));
      request.files.add(resFile);
    } else {
      request.fields['image'] = "";
    }

    final data = await request.send();
    final response = await http.Response.fromStream(data);
    print("response ${response.statusCode}");

    if (response.statusCode == 201) {
      var data = json.decode(response.body);
      print("Data $data");
      ResponseModel model = ResponseModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }


}
