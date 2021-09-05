import 'dart:convert';

import 'package:kasir_mri/config/api.dart';
import 'package:kasir_mri/models/Auth_model.dart';
import 'package:http/http.dart' as http;

abstract class AuthRepo {
  Future<AuthModel> login(String email, String pass);

}

class AuthRepoImpl implements AuthRepo {
  @override
  Future<AuthModel> login(String email, String pass) async{
    var _response = await http.post(Uri.parse(Api.instance.loginURL), body: {
      "email": email,
      "password" : pass,
      });
    print("Login ${_response.statusCode}");
    if (_response.statusCode == 201) {
      var data = json.decode(_response.body);
      print("Data $data");
      AuthModel model = AuthModel.fromJson(data);
      return model;
    } else {
      throw Exception();
    }
  }
  
}