import 'dart:convert';
import 'dart:io';

import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/produk_model.dart';
import 'package:kasir_mri/models/response_model.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

abstract class ProdukRepository {
  Future<ProdukModel> fetchProduks();
  Future<ProdukModel> fetchProduksByIdKategori(int id);
  Future<ResponseModel> produkStore(File? file, Produk produk);
  Future<ResponseModel> produkUpdate(File file, String id, Produk produk);
  Future<ResponseModel> produkDelete(String id);
}

class ProdukRepositoryImpl extends ProdukRepository {
  static const TAG = "ProdukRepositoryImpl";

  @override
  Future<ResponseModel> produkStore(File? file, Produk produk) async {
    var request =
        new http.MultipartRequest("POST", Uri.parse(Api.instance.produkURL));

    request.fields['kategori_id'] = produk.kategoriId.toString();
    request.fields['nama'] = produk.nama;
    request.fields['harga'] = produk.harga;
    request.fields['modal'] = produk.modal;
    request.fields['id'] = produk.id.toString();
    request.fields['foto'] = produk.foto;

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

  @override
  Future<ResponseModel> produkUpdate(
      File file, String id, Produk produk) async {
    var request = new http.MultipartRequest(
        "POST", Uri.parse(Api.instance.produkURL + "/" + id));

    request.fields['kategori_id'] = produk.kategoriId.toString();
    request.fields['nama'] = produk.nama;
    request.fields['harga'] = produk.harga;
    request.fields['modal'] = produk.modal;
    request.fields['id'] = id;
    request.fields['foto'] = produk.foto;

    final resFile = await http.MultipartFile.fromPath('image', file.path,
        contentType: new MediaType('application', 'x-tar'));
    request.files.add(resFile);

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

  @override
  Future<ProdukModel> fetchProduks() async {
    var _response = await http.get(Uri.parse(Api.instance.produkURL));
    print("$TAG, fetchProduks ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchKategoris true ");
      var data = json.decode(_response.body);
      print("Data $data");
      ProdukModel model = ProdukModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<ResponseModel> produkDelete(String id) async {
    var _response =
        await http.delete(Uri.parse(Api.instance.produkURL + "/" + id));
    print("$TAG, produkDelete ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchKategoris true ");
      var data = json.decode(_response.body);
      print("Data $data");
      ResponseModel model = ResponseModel.fromJson(data);
      return model;
    } else {
      print("$TAG getLogin else");
      throw Exception();
    }
  }

  @override
  Future<ProdukModel> fetchProduksByIdKategori(int id) async {
    var _response = await http.get(Uri.parse(Api.instance.produkURL+"/"+id.toString()));
    print("$TAG, fetchProduksByIdKategori ${_response.statusCode}");
    if (_response.statusCode == 201) {
      print("$TAG fetchProduksByIdKategori true ");
      var data = json.decode(_response.body);
      print("Data $data");
      ProdukModel model = ProdukModel.fromJson(data);
      return model;
    } else {
      print("$TAG fetchProduksByIdKategori else");
      throw Exception();
    }
  }
}
