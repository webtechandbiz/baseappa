import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../main.dart';

@JsonSerializable()
class FormData {
  String? usernamedolifrives;
  String? passwordwrochophag;
  String? authenticationToken;
  bool? success;
  List<dynamic>? spuntieducativi;

  FormData({
    this.usernamedolifrives,
    this.passwordwrochophag,
    this.authenticationToken,
    this.success,
    this.spuntieducativi
  });

  factory FormData.fromJson(Map<String, dynamic> json) =>
      _$FormDataFromJson(json);

  Map<String, dynamic> toJson() => _$FormDataToJson(this);
}

class LoginHttp extends StatefulWidget {
  final http.Client? httpClient;

  const LoginHttp({
    this.httpClient,
    Key? key,
  }) : super(key: key);

  @override
  _LoginHttpState createState() => _LoginHttpState();
}

class _LoginHttpState extends State<LoginHttp> {
  FormData firstFormData = FormData();
  FormData formData = FormData();

  String _username_saved = '';
  String _password_saved = '';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsLoginFormParameters;

    _username_saved = args.username;
    _password_saved = args.password;

    final Uri WS_url_login = Uri.parse(''); //#change

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
        formData.usernamedolifrives = value;
      },
    );

    TextEditingController _passwordController = TextEditingController(text: _password_saved.toString());
    TextFormField _passwordTFF = TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        filled: true,
        labelText: 'Password', //#change
        border: InputBorder.none, //#change
      ),
      obscureText: true,
      onChanged: (value) {
        formData.passwordwrochophag = value;
      },
    );

    return Scaffold(
      //#login app bar
      appBar: AppBar(
        backgroundColor: Colors.blue, //#change colore (del titolo)
        title: const Text('Accedi'), //#change titolo sopra campi di login
      ),
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  _usernameTFF,
                  _passwordTFF,

                  TextButton(
                    child: const Text(
                        'Accedi',
                        style: TextStyle(
                            //#change fontWeight: FontWeight.bold,
                            color: Colors.black, //#change colore (del bottone per accedere)
                        ),
                    ), //#change bottone per accedere
                    onPressed: () async {
                      Map<String, String> headers = {
                        "Content-type": "application/json; charset=UTF-8"
                      };

                      if (_username_saved.toString() != '') {
                        formData.usernamedolifrives = _username_saved.toString();
                      }
                      if (_password_saved.toString() != '') {
                        formData.passwordwrochophag = _password_saved.toString();
                      }

                      //# Login via WS
                      String json = '{"usernamedolifrives": "${_usernameController.text}", "passwordwrochophag": "${formData.passwordwrochophag}"}';
                      Response response = await post(WS_url_login, headers: headers, body: json);
                      int statusCode = response.statusCode;
                      String body = response.body;

                      if (response.statusCode == 200) {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('_username',formData.usernamedolifrives?.toString() ?? '');
                        prefs.setString('_password',formData.passwordwrochophag?.toString() ?? '');

                        late Future<Homedata> futureHomedata;
                        futureHomedata = fetchHomedata(response);

                        Navigator.pushNamed(
                            context,
                            '/home',
                            arguments: ScreenArgumentsFutureFormDataParameters(
                                futureHomedata
                            ),
                        );
                        /* //# change se hai bisogno di andare direttamente in una scheda
                        Navigator.pushNamed(
                            context,
                            '/scheda',
                            arguments: ScreenArgumentsSchedaParameters(1)
                        );
                        */

                      } else {
                        print('loginfailed');
                        _showDialog('Login errato, riprova.');
                        //#change throw Exception('Login failed.');
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



class Homedata {
  bool? success;
  String authenticationToken;
  List<dynamic>? spuntieducativi;

  Homedata({
    required this.authenticationToken,
    required this.success,
    required this.spuntieducativi
  });

  factory Homedata.fromJson(Map<String, dynamic> json) {
    return Homedata(
      authenticationToken: json['authenticationToken'],
      success: json['success'],
      spuntieducativi: json['spuntieducativi']
    );
  }
}

Future<Homedata> fetchHomedata(response) async {
  if (response.statusCode == 200) {
    return Homedata.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load Homedata');
  }
}


FormData _$FormDataFromJson(Map<String, dynamic> json) {
  return FormData(
      usernamedolifrives: json['usernamedolifrives'] as String?,
      passwordwrochophag: json['passwordwrochophag'] as String?,
      authenticationToken: json['authenticationToken'] as String?,
      success: json['success'] as bool?,
      spuntieducativi: json['spuntieducativi'] as List<dynamic>?
  );
}

Map<String, dynamic> _$FormDataToJson(FormData instance) => <String, dynamic>{
  'usernamedolifrives': instance.usernamedolifrives,
  'passwordwrochophag': instance.passwordwrochophag,
};
