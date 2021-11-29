import 'dart:convert';

import 'package:baseappahome/main.dart';
import 'package:baseappahome/src/config/app_config.dart';
import 'package:flutter/material.dart';
import 'package:baseappahome/src/auth/http/login_http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:baseappahome/src/design/design_objects.dart';

//#https://flutter.dev/docs/cookbook/navigation/navigation-basics
class HomeRoute extends StatefulWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  State<HomeRoute> createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  Future<void> setAuthenticationToken(String authenticationtoken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("authenticationtoken", authenticationtoken);
  }
  DesignObjects designobjects = new DesignObjects();
  Future<String> _getAuthenticationToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authenticationtoken') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    List<ContentBox> _data1List = [];
    List<ContentBox> _data2List = [];
    String imgsrc = '';
    final homeArgs = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsFutureLoginFormDataParameters;
    Future<String> _authtokenlogin_saved = _getAuthenticationToken();
    late Future<Homedata> futureHomedata = homeArgs.futureLoginFormData;

    return Scaffold(
      drawer: designobjects.get_drawer(context, _authtokenlogin_saved), //# change per il menu
      appBar: AppBar(
        backgroundColor: Colors.blue, //#change colore (del titolo)
        title: const Text('Home'), //#change titolo sopra campi di login
      ),
      body: FutureBuilder<Homedata>(
        future: futureHomedata,
        builder: (context, snapshot) {

          if (snapshot.hasData) {
            String authenticationtoken = snapshot.data!.authenticationToken;
            setAuthenticationToken(authenticationtoken);

            //#section 1
            for (var item in snapshot.data!.spuntieducativi!){
              if(item['imgurl'] != false && item['imgurl'] != ''){
                imgsrc = item['imgurl'];
              }else{
                imgsrc = ''; //#change url immagina di default se l'immagine manca
              }

              _data1List.add(
                  ContentBox(
                    authenticationToken: authenticationtoken,
                    IDitem: item['_ID'],
                    item: item,
                    imagePath: imgsrc,
                    title: item['titlelenght'],
                    excerpt: item['titlelenght']
                  )
              );
            }
            Section section1 = new Section(sectionTitle: 'Spunti educativi 1', dataList: _data1List);

            //#section 2
            for (var item in snapshot.data!.spuntieducativi!){
              if(item['imgurl'] != false && item['imgurl'] != ''){
                imgsrc = item['imgurl'];
              }else{
                imgsrc = ''; //#change url immagina di default se l'immagine manca
              }

              _data2List.add(
                  ContentBox(
                      authenticationToken: authenticationtoken,
                      IDitem: item['_ID'],
                      item: item,
                      imagePath: imgsrc,
                      title: item['titlelenght'],
                      excerpt: item['titlelenght']
                  )
              );
            }
            Section section2 = new Section(sectionTitle: 'Spunti educativi 2', dataList: _data2List);

            Sections sections = new Sections(section1: section1, section2: section2);
            //DesignObjects designobjects = new DesignObjects();
            List <Widget> homeSections = [
              designobjects.horizontalScrollSection(sections.section1),
              Text('asdasdasdasd'),
              designobjects.verticalScrollSection(sections.section2),
              designobjects.verticalSection(sections.section2),
              Column(
                children: [
                  TextButton(
                    child: const Text(
                      'Button1',
                      style: TextStyle(
                        //#change fontWeight: FontWeight.bold,
                        color: Colors.white, //#change colore (del bottone per accedere)
                      ),
                    ), //#change bottone per accedere
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(MediaQuery.of(context).size.width/2,40)
                    ),
                    onPressed: () async {

                    },
                  ),
                ],
              ), //# 1 column, 1 button
              Column(
                children: [
                  Row(
                    children: [
                      TextButton(
                        child: const Text(
                          'Button1',
                          style: TextStyle(
                            //#change fontWeight: FontWeight.bold,
                            color: Colors.white, //#change colore (del bottone per accedere)
                          ),
                        ), //#change bottone per accedere
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(MediaQuery.of(context).size.width/2,40)
                        ),
                        onPressed: () async {

                        },
                      ),
                      TextButton(
                        child: const Text(
                          'Button2',
                          style: TextStyle(
                            //#change fontWeight: FontWeight.bold,
                            color: Colors.white, //#change colore (del bottone per accedere)
                          ),
                        ), //#change bottone per accedere
                        style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                            minimumSize: Size(MediaQuery.of(context).size.width/2,40)
                        ),
                        onPressed: () async {

                        },
                      ),
                    ],
                  ),
                ],
              ), //# 2 columns, 2 buttons
              Column(
                children: [
                  TextButton(
                    child: const Text(
                      'Button3',
                      style: TextStyle(
                        //#change fontWeight: FontWeight.bold,
                        color: Colors.white, //#change colore (del bottone per accedere)
                      ),
                    ), //#change bottone per accedere
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        minimumSize: Size(MediaQuery.of(context).size.width,40)
                    ),
                    onPressed: () async {

                    },
                  ),
                ],
              ), //# 1 column, 1 button
            ];

            return Scaffold(
              body: Column(
                children: <Widget>[
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container( //# contenitore di tutta la pagina
                        //# l'altezza totale dovrebbe essere la somma di tutte le sezioni + uno spazio vuoto
                        // oppure se le sezioni sono dinamiche, l'altezza non viene impostata
                        // e per avere uno spazio vuoto in fondo basta aggiungere un divider o un Widget vuoto
                        //height: MediaQuery.of(context).size.height + 500,
                        child: Column( //# una colonna per contenuti dinamici e statici
                          children: homeSections,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          // By default, show a loading spinner.
          return const CircularProgressIndicator();
        },
      )
    );
  }
}
