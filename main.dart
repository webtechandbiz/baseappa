import 'package:baseappahome/src/auth/http/forgottenpassword_http.dart';
import 'package:baseappahome/src/auth/http/logout_http.dart';
import 'package:baseappahome/src/auth/http/subscribe_http.dart';
import 'package:baseappahome/src/config/app_config.dart';
import 'package:baseappahome/src/screens/scheda.dart';
import 'package:baseappahome/src/screens/homegrid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart'; //#per memorizzare le credenziali
import 'src/auth/http/login_http.dart';

void main() {runApp(const BaseApp());}

final String splash_bg_page = AppConfig.splash_bg_page;

//# questo prepara la route "signin_http"
//# che viene usata dopo (al click del bottone)
//# per andare alla Login
final mynavigationroutes = [
  MyNavigationRoutes(
    name: 'Sign in with HTTP',
    route: '/signin_http',
    builder: (context) => LoginHttp(), //# sta dentro login_http.dart
  ),
  MyNavigationRoutes(
    name: 'Sign out with HTTP',
    route: '/signout_http',
    builder: (context) => LogoutHttp(), //# sta dentro logout_http.dart
  ),
  MyNavigationRoutes(
    name: 'Subscribe in with HTTP',
    route: '/subscribe_http',
    builder: (context) => SubscribeHttp(),
  ),
  MyNavigationRoutes(
    name: 'Forgottenpassword in with HTTP',
    route: '/forgottenpassword_http',
    builder: (context) => ForgottenpasswordHttp(),
  ),
  MyNavigationRoutes(
    name: 'Home',
    route: '/home',
    builder: (context) => HomeRoute(), //# sta dentro login_http.dart
  ),
  MyNavigationRoutes(
    name: 'Scheda',
    route: '/scheda',
    builder: (context) => Scheda(), //# sta dentro login_http.dart
  ),
];

class BaseApp extends StatelessWidget { //# viene chiamata dal main()
  const BaseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: Map.fromEntries(mynavigationroutes.map((d) => MapEntry(d.route, d.builder))),
      home: CoverPage(title: ''), //#change
    );
  }
}

class CoverPage extends StatefulWidget {
  const CoverPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _CoverPageState createState() => _CoverPageState();
}

class _CoverPageState extends State<CoverPage> {
  void _navigateToLogin() async {
    //#PREPARA i dati per la login
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //#here
      //prefs.remove('_username');
      //prefs.remove('_password');
      //#--
      //#changeif-3412 String _username_saved =  prefs.getString('_username') ?? '';
      //#changeif-3412 String _password_saved =  prefs.getString('_password') ?? ''; //#changeif-3412
      String _authtokenlogin_saved = prefs.getString('authenticationtoken') ?? '';

      //#NAVIGA VERO LA LOGIN
      //#quando il bottone viene cliccato,
      //#naviga verso la route "signin_http"
      //#- definita alle prime righe si chiama LoginHttp() -
      //#passando dei parametri con ScreenArgumentsLoginFormParameters()
      Navigator.pushNamed(
          context,
          '/signin_http',
          arguments: ScreenArgumentsLoginFormParameters(
            //#changeif-3412 _username_saved,
            //#changeif-3412 _password_saved,
              _authtokenlogin_saved
          )
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //#splash pag appbar
      /*appBar: AppBar(title: Text(widget.title),),#change */
      body: Container(
        /*decoration: BoxDecoration( //#change: use it is if internet is needed by init
            image: DecorationImage(
                image: NetworkImage(splash_bg_page), fit: BoxFit.cover
            )
        ),*/
        decoration: const BoxDecoration( //#change: use it is if internet is not needed by init
            image: DecorationImage(
                image: AssetImage(
                    'assets/images/_auth/hd-forgottenpassword.jpg'
                ), fit: BoxFit.cover
            )
        ),

        //# testi al centro della splash page
        /*
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            /*const Text(
              'Testo al centro',
            ),*/
          ],
        ),*/
      ),
      floatingActionButton: FloatingActionButton( //#splashpage: bottone per procedere
        backgroundColor: Colors.red, //#change colore dell'icona
        onPressed: _navigateToLogin,
        tooltip: '', //#change
        child: const Icon(Icons.arrow_forward, size: 40), //#change icona + size dell'icona
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

//# -- classes
class MyNavigationRoutes { //# questo è l'oggetto generico per i nomi e gli indirizzi delle route
  final String name;
  final String route;
  final WidgetBuilder builder;

  const MyNavigationRoutes({required this.name, required this.route, required this.builder});
}
//# -- ScreenArgumentsFormParameters
class ScreenArgumentsLoginFormParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  //#changeif-3412 final String username;
  //#changeif-3412 final String password;
  final String authtokenlogin;

  //#changeif-3412 ScreenArgumentsLoginFormParameters(this.username, this.password);
  ScreenArgumentsLoginFormParameters(this.authtokenlogin);
}
class ScreenArgumentsLogoutFormParameters {
  final Future<String> authtokenlogin;

  ScreenArgumentsLogoutFormParameters(this.authtokenlogin);
}
class ScreenArgumentsSubscribeFormParameters { //# questa serve per navigare verso la pagina di Registrazione
  //# in questo caso, non viene passato alcun parametro
  ScreenArgumentsSubscribeFormParameters();
}
class ScreenArgumentsForgottenpasswordFormParameters { //# questa serve per passare alla [classe] i dati memorizzati

  ScreenArgumentsForgottenpasswordFormParameters();
}

//# -- ScreenArguments Response Future
class ScreenArgumentsHomeResponseParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  final Response response;

  ScreenArgumentsHomeResponseParameters(this.response);
}
class ScreenArgumentsFutureLoginFormDataParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  late Future<Homedata> futureLoginFormData;

  ScreenArgumentsFutureLoginFormDataParameters(this.futureLoginFormData);
}

class ScreenArgumentsSchedaParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  String authenticationToken;
  int id;

  ScreenArgumentsSchedaParameters(this.authenticationToken, this.id);
}
