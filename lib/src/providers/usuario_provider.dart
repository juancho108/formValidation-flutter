import 'dart:convert';

import 'package:http/http.dart' as http;


class UsuarioProvider {

  final String _firebaseToken = 'AIzaSyDYPUxU4F98mD333Zr_MkqQaWHbygQmZFE';


  Future<Map<String,dynamic>> login(String email, String password) async{

    final authData = {
      'email' : email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=${_firebaseToken}',
    body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    // print(decodedResp);

    if (decodedResp.containsKey('idToken')) {

      //TODO: salvar token storake
      return {'ok': true, 'token':decodedResp['idToken']};
    }else{
      return {'ok': false, 'token':decodedResp['error']['message']};
    }

  }





  Future<Map<String,dynamic>> nuevoUsuario(String email, String password) async{

    final authData = {
      'email' : email,
      'password': password,
      'returnSecureToken': true
    };

    final resp = await http.post('https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=${_firebaseToken}',
    body: json.encode(authData)
    );

    Map<String, dynamic> decodedResp = json.decode(resp.body);

    // print(decodedResp);

    if (decodedResp.containsKey('idToken')) {

      //TODO: salvar token storake
      return {'ok': true, 'token':decodedResp['idToken']};
    }else{
      return {'ok': false, 'token':decodedResp['error']['message']};
    }

  }



}