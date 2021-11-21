import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

@JsonSerializable()
class ForgottenpasswordFormData {
  String? usernamedolifrives;
  String? passwordwrochophag;
  String? authenticationToken;
  bool? success;
  List<dynamic>? spuntieducativi;

  ForgottenpasswordFormData({
    this.usernamedolifrives,
    this.passwordwrochophag,
    this.authenticationToken,
    this.success,
    this.spuntieducativi
  });

  factory ForgottenpasswordFormData.fromJson(Map<String, dynamic> json) =>
      _$ForgottenpasswordFormDataFromJson(json);

  Map<String, dynamic> toJson() => _$ForgottenpasswordFormDataToJson(this);
}

class ForgottenpasswordHttp extends StatefulWidget {
  final http.Client? httpClient;

  const ForgottenpasswordHttp({
    this.httpClient,
    Key? key,
  }) : super(key: key);

  @override
  _ForgottenpasswordHttpState createState() => _ForgottenpasswordHttpState();
}

class _ForgottenpasswordHttpState extends State<ForgottenpasswordHttp> {
  ForgottenpasswordFormData firstForgottenpasswordFormData = ForgottenpasswordFormData();
  ForgottenpasswordFormData forgottenpasswordFormData = ForgottenpasswordFormData();

  String _username_saved = '';
  String _password_saved = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsForgottenpasswordFormParameters;
    final Uri WS_url_forgottenpassword = Uri.parse('[ws-forgottenpassword-login-url]'); //#change

    Image _header_image =
    new Image.asset(
      'assets/images/_auth/hd-forgottenpassword.jpg',
      fit: BoxFit.cover,
    );

    TextEditingController _usernameController = TextEditingController(text: _username_saved.toString());
    TextFormField _usernameTFF = TextFormField(
      controller: _usernameController,
      autofocus: true,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Email', //#change
        filled: true,
        hintText: 'Your email address', //#change
        /* //#change
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),*/
        border: InputBorder.none, //#change
      ),
      onChanged: (value) {
        forgottenpasswordFormData.usernamedolifrives = value;
      },
    );


    return Scaffold(
      //#forgottenpassword app bar
      appBar: AppBar(
        backgroundColor: Colors.blue, //#change colore (del titolo)
        title: const Text('Recupera passowrd'), //#change titolo sopra campi di forgottenpassword
      ),
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  _header_image,
                  _usernameTFF,

                  TextButton(
                    child: const Text(
                      'Recupera password',
                      style: TextStyle(
                        //#change fontWeight: FontWeight.bold,
                        color: Colors.white, //#change colore (del bottone per accedere)
                      ),
                    ), //#change bottone per accedere
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(MediaQuery.of(context).size.width/2-20,40)
                    ),
                    onPressed: () async {
                      Map<String, String> headers = {
                        "Content-type": "application/json; charset=UTF-8"
                      };

                      if (_username_saved.toString() != '') {
                        forgottenpasswordFormData.usernamedolifrives = _username_saved.toString();
                      }
                      if (_password_saved.toString() != '') {
                        forgottenpasswordFormData.passwordwrochophag = _password_saved.toString();
                      }

                      //# Forgottenpassword via WS
                      String json = '{"usernamedolifrives": "${_usernameController.text}", "passwordwrochophag": "${forgottenpasswordFormData.passwordwrochophag}"}';
                      Response response = await post(WS_url_forgottenpassword, headers: headers, body: json);
                      int statusCode = response.statusCode;
                      String body = response.body;

                      if (response.statusCode == 200) {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('_username',forgottenpasswordFormData.usernamedolifrives?.toString() ?? '');
                        prefs.setString('_password',forgottenpasswordFormData.passwordwrochophag?.toString() ?? '');

                        _showDialog("Controlla la tua email");
                        Navigator.pop(context);

                      } else {
                        print('forgottenpasswordfailed');
                        _showDialog('Forgottenpassword errato, riprova.');
                        //#change throw Exception('Forgottenpassword failed.');
                      }
                    },
                  ),
                ].expand(
                      (widget) =>
                  [
                    widget,
                    const SizedBox(
                      height: 24,
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }


  void _showDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

}


ForgottenpasswordFormData _$ForgottenpasswordFormDataFromJson(Map<String, dynamic> json) {
  return ForgottenpasswordFormData(
      usernamedolifrives: json['usernamedolifrives'] as String?,
      passwordwrochophag: json['passwordwrochophag'] as String?,
      authenticationToken: json['authenticationToken'] as String?,
      success: json['success'] as bool?,
      spuntieducativi: json['spuntieducativi'] as List<dynamic>?
  );
}

Map<String, dynamic> _$ForgottenpasswordFormDataToJson(ForgottenpasswordFormData instance) => <String, dynamic>{
  'usernamedolifrives': instance.usernamedolifrives,
  'passwordwrochophag': instance.passwordwrochophag,
};
