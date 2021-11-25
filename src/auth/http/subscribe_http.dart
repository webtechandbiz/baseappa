import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../../main.dart';

@JsonSerializable()
class SubscribeFormData {
  String? personnamedolifrives;
  String? personsurnamedolifrives;
  String? usernamedolifrives;
  String? passwordwrochophag;
  String? authenticationToken;
  bool? success;

  SubscribeFormData({
    this.personnamedolifrives,
    this.personsurnamedolifrives,
    this.usernamedolifrives,
    this.passwordwrochophag,
    this.authenticationToken,
    this.success
  });

  factory SubscribeFormData.fromJson(Map<String, dynamic> json) =>
      _$subscribeFormDataFromJson(json);

  Map<String, dynamic> toJson() => _$subscribeFormDataToJson(this);
}

class SubscribeHttp extends StatefulWidget {
  final http.Client? httpClient;

  const SubscribeHttp({
    this.httpClient,
    Key? key,
  }) : super(key: key);

  @override
  _SubscribeHttpState createState() => _SubscribeHttpState();
}

class _SubscribeHttpState extends State<SubscribeHttp> {
  SubscribeFormData firstsubscribeFormData = SubscribeFormData();
  SubscribeFormData subscribeFormData = SubscribeFormData();

  //# https://docs.flutter.dev/cookbook/forms/text-field-changes
  TextEditingController _personnameController = TextEditingController();
  TextEditingController _personsurnameController = TextEditingController();
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsSubscribeFormParameters;
    final Uri WS_url_Subscribe = Uri.parse(''); //#change

    Image _header_image =
      new Image.asset(
        'assets/images/_auth/hd-subscribe.jpg',
        fit: BoxFit.cover,
      );

    TextFormField _personnameTFF = TextFormField(
      controller: _personnameController,
      //autofocus: true,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Nome', //#change
        filled: true,
        hintText: '', //#change
        /* //#change
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),*/
        border: InputBorder.none, //#change
      ),
      onChanged: (value) {
        subscribeFormData.personnamedolifrives = value;
      },
    );
    TextFormField _personsurnameTFF = TextFormField(
      controller: _personsurnameController,
      //autofocus: true,
      textInputAction: TextInputAction.next,
      decoration: const InputDecoration(
        labelText: 'Cognome', //#change
        filled: true,
        hintText: '', //#change
        /* //#change
        border: OutlineInputBorder(
          borderRadius: const BorderRadius.all(
            const Radius.circular(8.0),
          ),
        ),*/
        border: InputBorder.none, //#change
      ),
      onChanged: (value) {
        subscribeFormData.personsurnamedolifrives = value;
      },
    );
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
        subscribeFormData.usernamedolifrives = value;
      },
    );
    TextFormField _passwordTFF = TextFormField(
      controller: _passwordController,
      decoration: const InputDecoration(
        filled: true,
        labelText: 'Password', //#change
        border: InputBorder.none, //#change
      ),
      obscureText: true,
      onChanged: (value) {
        subscribeFormData.passwordwrochophag = value;
      },
    );

    return Scaffold(
      //#Subscribe app bar
      appBar: AppBar(
        backgroundColor: Colors.blue, //#change colore (del titolo)
        title: const Text('Registrati'), //#change titolo sopra campi di Subscribe
      ),
      body: Form(
        child: Scrollbar(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ...[
                  _header_image,
                  _personnameTFF,
                  _personsurnameTFF,
                  _usernameTFF,
                  _passwordTFF,

                  TextButton(
                    child: const Text(
                      'Registrati',
                      style: TextStyle(
                        //#change fontWeight: FontWeight.bold,
                        color: Colors.white, //#change colore del bottone
                      ),
                    ), //#change bottone per registrarsi
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(MediaQuery.of(context).size.width/2-20,40)
                    ),
                    onPressed: () async {
                      Map<String, String> headers = {
                        "Content-type": "application/json; charset=UTF-8"
                      };

                      //# Subscribe via WS
                      String json =
                          '{"usernamedolifrives": "${_usernameController.text}", "passwordwrochophag": "${subscribeFormData.passwordwrochophag}"'
                          ', "personnamedolifrives": "${subscribeFormData.personnamedolifrives}"'
                          ', "personsurnamedolifrives": "${subscribeFormData.personsurnamedolifrives}"}';
                      Response response = await post(WS_url_Subscribe, headers: headers, body: json);
                      int statusCode = response.statusCode;
                      String body = response.body;
print('fp');
print(body);
                      if (response.statusCode == 200) {
                        _showDialogSubscribe('Registrazione avvenuta con successo, prova ad accedere.');
                      } else {
                        print('subscribefailed');
                        _showDialogSubscribe('Subscribe errato, riprova.');
                        //#change throw Exception('Subscribe failed.');
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


  void _showDialogSubscribe(String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () =>  Navigator.pushNamedAndRemoveUntil(context,'/',(_) => false),
          ),
        ],
      ),
    );
  }

}



SubscribeFormData _$subscribeFormDataFromJson(Map<String, dynamic> json) {
  return SubscribeFormData(
      personnamedolifrives: json['personnamedolifrives'] as String?,
      personsurnamedolifrives: json['personsurnamedolifrives'] as String?,
      usernamedolifrives: json['usernamedolifrives'] as String?,
      passwordwrochophag: json['passwordwrochophag'] as String?,
      authenticationToken: json['authenticationToken'] as String?,
      success: json['success'] as bool?
  );
}

Map<String, dynamic> _$subscribeFormDataToJson(SubscribeFormData instance) => <String, dynamic>{
  'personnamedolifrives': instance.personnamedolifrives,
  'personsurnamedolifrives': instance.personsurnamedolifrives,
  'usernamedolifrives': instance.usernamedolifrives,
  'passwordwrochophag': instance.passwordwrochophag
};
