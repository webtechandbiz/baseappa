import 'package:baseappahome/src/screens/scheda.dart';
import 'package:baseappahome/src/screens/homegrid.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart'; //#per memorizzare le credenziali
import 'src/login_http.dart';

void main() {runApp(const CoverPage());}

final String splash_bg_page = '[cover-image-url]'; //#change

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

class CoverPage extends StatelessWidget { //# viene chiamata dal main()
  const CoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '',
      theme: ThemeData(primarySwatch: Colors.teal),
      routes: Map.fromEntries(mynavigationroutes.map((d) => MapEntry(d.route, d.builder))),
      home: MyHomePage(title: ''), //#change
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  void _navigateToLogin() async {
    //#PREPARA i dati per la login
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      //#here
      //prefs.remove('_username');
      //prefs.remove('_password');
      //#--
      String _username_saved =  prefs.getString('_username') ?? '';
      String _password_saved =  prefs.getString('_password') ?? '';

      //#NAVIGA VERO LA LOGIN
      //#quando il bottone viene cliccato,
      //#naviga verso la route "signin_http"
      //#- definita alle prime righe si chiama LoginHttp() -
      //#passando dei parametri con ScreenArgumentsLoginFormParameters()
      Navigator.pushNamed(
          context,
          '/signin_http',
          arguments: ScreenArgumentsLoginFormParameters(
            _username_saved,
            _password_saved,
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
        decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(splash_bg_page), fit: BoxFit.cover
            )
        ),

        //# testi al centro della splash page
        /*
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            /*const Text(
              'Testo al centro',
            ),
            Text(
              style: Theme.of(context).textTheme.headline4,
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
class ScreenArgumentsLoginFormParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  final String username;
  final String password;

  ScreenArgumentsLoginFormParameters(this.username, this.password);
}
class ScreenArgumentsHomeResponseParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  final Response response;

  ScreenArgumentsHomeResponseParameters(this.response);
}
class ScreenArgumentsFutureFormDataParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  late Future<Homedata> futureFormData;

  ScreenArgumentsFutureFormDataParameters(this.futureFormData);
}
class ScreenArgumentsSchedaParameters { //# questa serve per passare alla LoginHttp() i dati memorizzati
  String authenticationToken;
  int id;

  ScreenArgumentsSchedaParameters(this.authenticationToken, this.id);
}
