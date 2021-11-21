import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

@JsonSerializable()
class LoginFormData {
  String? usernamedolifrives;
  String? passwordwrochophag;
  String? authenticationToken;
  bool? success;
  List<dynamic>? spuntieducativi;

  LoginFormData({
    this.usernamedolifrives,
    this.passwordwrochophag,
    this.authenticationToken,
    this.success,
    this.spuntieducativi
  });

  factory LoginFormData.fromJson(Map<String, dynamic> json) =>
      _$LoginFormDataFromJson(json);

  Map<String, dynamic> toJson() => _$LoginFormDataToJson(this);
}

class LoginHttp extends StatefulWidget {
  const LoginHttp({
    Key? key,
  }) : super(key: key);

  @override
  _LoginHttpState createState() => _LoginHttpState();
}

class _LoginHttpState extends State<LoginHttp> {
  LoginFormData firstLoginFormData = LoginFormData();
  LoginFormData loginFormData = LoginFormData();

  //#changeif-3412 String _username_saved = '';
  //#changeif-3412 String _password_saved = '';
  String _authtokenlogin = '';

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Future<void> _loginWithUserPassword(WS_url_login, _usernametext, _passwordtext) async {
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };

    String json = '{"usernamedolifrives": "${_usernametext}", "passwordwrochophag": "${_passwordtext}"}';
    Response response = await post(WS_url_login, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      //#changeif-3412 prefs.setString('_username',loginFormData.usernamedolifrives?.toString() ?? '');
      //#changeif-3412 prefs.setString('_password',loginFormData.passwordwrochophag?.toString() ?? '');

      late Future<Homedata> futureHomedata;
      futureHomedata = fetchHomedata(response);

      Navigator.pushNamed(
        context,
        '/home',
        arguments: ScreenArgumentsFutureLoginFormDataParameters(
            futureHomedata
        ),
      );

    } else {
      print('loginfailed');
      _showDialog('Login errato, riprova.');
      //#change throw Exception('Login failed.');
    }
  }

  Future<void> _loginWithAuthToken(WS_url_authtoken_login, _authtokenlogin) async {
    Map<String, String> headers = {
      "Content-type": "application/json; charset=UTF-8"
    };
    String json = '{"authtokenloginaowjewlr": "${_authtokenlogin}"}';

    print('******');
    print(json);
    Response response = await post(WS_url_authtoken_login, headers: headers, body: json);
    int statusCode = response.statusCode;
    String body = response.body;

    if (response.statusCode == 200) {
      final prefs = await SharedPreferences.getInstance();
      //#changeif-3412 prefs.setString('_username',loginFormData.usernamedolifrives?.toString() ?? '');
      //#changeif-3412 prefs.setString('_password',loginFormData.passwordwrochophag?.toString() ?? '');
      late Future<Homedata> futureHomedata;
      futureHomedata = fetchHomedata(response);

      Navigator.pushNamed(
        context,
        '/home',
        arguments: ScreenArgumentsFutureLoginFormDataParameters(
            futureHomedata
        ),
      );

    } else {
      print('loginauthtokenfailed');
      print(body);

      final prefs = await SharedPreferences.getInstance();
      prefs.setString("authenticationtoken", ""); //# se non funziona, svuota l'authenticationtoken memorizzato
      _showAuthlokenLoginFailedDialog('Login automatico non ha funzionato, inserisci le credenziali e riprova ad accedere.');
      String _authtokenlogin_saved = prefs.getString('authenticationtoken') ?? '';
      print('@@@@@@@@@@');
      print(_authtokenlogin_saved);
      //throw Exception('Login authtoken failed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    final argsLogin = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsLoginFormParameters;
    final Uri WS_url_login = Uri.parse('[ws-login-url]'); //#change
    final Uri WS_url_authtoken_login = Uri.parse('[ws-authtoken-login-url]'); //#change

    //#changeif-3412 _username_saved = args.username;
    //#changeif-3412 _password_saved = args.password;
    _authtokenlogin = argsLogin.authtokenlogin;

    if(_authtokenlogin != ''){
      print('try with _authtokenlogin');
      _loginWithAuthToken(WS_url_authtoken_login, _authtokenlogin);
    }else{
      print('no _authtokenlogin found. Login with credentials');
    }

    Image _header_image =
      new Image.asset(
        'assets/images/_auth/hd-login.jpg',
        fit: BoxFit.cover,
      );

    //TextEditingController _usernameController = TextEditingController(text: _username_saved.toString());
    TextFormField _usernameTFF = TextFormField(
      controller: _usernameController,
      //autofocus: true,
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
        loginFormData.usernamedolifrives = value;
      },
    );

    //TextEditingController _passwordController = TextEditingController(text: _password_saved.toString());
    TextFormField _passwordTFF = TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        filled: true,
        labelText: 'Password', //#change
        border: InputBorder.none, //#change
      ),
      obscureText: true,
      onChanged: (value) {
        loginFormData.passwordwrochophag = value;
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
                  _header_image,
                  _usernameTFF,
                  _passwordTFF,

                  TextButton(
                    child: const Text(
                        'Accedi',
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
/*
                      if (_username_saved.toString() != '') {
                        loginFormData.usernamedolifrives = _username_saved.toString();
                      }
                      if (_password_saved.toString() != '') {
                        loginFormData.passwordwrochophag = _password_saved.toString();
                      }*/

                      String _usernametext = _usernameController.text;
                      String _passwordtext = _passwordController.text; //loginFormData.passwordwrochophag;

                      _loginWithUserPassword(WS_url_login, _usernametext, _passwordtext);
                    },
                  ),
                  //# password dimenticata e registrazione
                  Divider(
                      color: Colors.black
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                child: TextButton(
                                  child: const Text(
                                    'Password dimenticata',
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: Size(MediaQuery.of(context).size.width/2-20,40)
                                  ),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context,
                                        '/forgottenpassword_http',
                                        arguments: ScreenArgumentsForgottenpasswordFormParameters()
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                child: TextButton(
                                  child: const Text(
                                    'Registrati',
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    minimumSize: Size(MediaQuery.of(context).size.width/2-20,40)
                                  ),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context,
                                        '/subscribe_http',
                                        arguments: ScreenArgumentsSubscribeFormParameters()
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*3*/
                      ],
                    ),
                  ),
                  //# login senza registrazione
                  Divider(
                      color: Colors.black
                  ),
                  Container(
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                child: TextButton(
                                  child: const Text(
                                    'Accesso senza registrazione',
                                    style: TextStyle(
                                        color: Colors.black
                                    ),
                                  ),
                                  style: TextButton.styleFrom(
                                      backgroundColor: Colors.blue,
                                      minimumSize: Size(MediaQuery.of(context).size.width/2-20,40)
                                  ),
                                  onPressed: () async {
                                    Navigator.pushNamed(
                                        context,
                                        '/forgottenpassword_http',
                                        arguments: ScreenArgumentsForgottenpasswordFormParameters()
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                        /*3*/
                      ],
                    ),
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


  void _showAuthlokenLoginFailedDialog(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK, capito'),
            onPressed: () => Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false),
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


LoginFormData _$LoginFormDataFromJson(Map<String, dynamic> json) {
  return LoginFormData(
      usernamedolifrives: json['usernamedolifrives'] as String?,
      passwordwrochophag: json['passwordwrochophag'] as String?,
      authenticationToken: json['authenticationToken'] as String?,
      success: json['success'] as bool?,
      spuntieducativi: json['spuntieducativi'] as List<dynamic>?
  );
}

Map<String, dynamic> _$LoginFormDataToJson(LoginFormData instance) => <String, dynamic>{
  'usernamedolifrives': instance.usernamedolifrives,
  'passwordwrochophag': instance.passwordwrochophag,
};
