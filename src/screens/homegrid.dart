import 'dart:convert';

import 'package:baseappahome/main.dart';
import 'package:flutter/material.dart';
import 'package:baseappahome/src/login_http.dart';

//#https://flutter.dev/docs/cookbook/navigation/navigation-basics
class HomeRoute extends StatelessWidget {
  const HomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Category> _categoryList = [];
    String imgsrc = '';
    final homeArgs = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsFutureFormDataParameters;

    print('home-args');
    print(homeArgs.futureFormData);
    late Future<Homedata> futureHomedata = homeArgs.futureFormData;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue, //#change colore (del titolo)
          title: const Text('Home'), //#change titolo sopra campi di login
        ),
        body: FutureBuilder<Homedata>(
          future: futureHomedata,
          builder: (context, snapshot) {

            if (snapshot.hasData) {
              String authenticationtoken = snapshot.data!.authenticationToken;

              for (var item in snapshot.data!.spuntieducativi!){
                if(item['imgurl'] != false && item['imgurl'] != ''){
                  imgsrc = item['imgurl'];
                }else{
                  imgsrc = ''; //#change url immagina di default se l'immagine manca
                }

                _categoryList.add(
                    Category(
                      authenticationToken: authenticationtoken,
                      IDitem: item['_ID'],
                      item: item,
                      imagePath: imgsrc,
                      title: item['titlelenght'],
                      activities: [],
                    )

                );
              }

              return GridView.count(
                crossAxisCount: 2, //#change numero colonne
                children: _categoryList.map((value) {
                  return Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(8), //#change spazio fra un box e l'altro
                    decoration:
                    BoxDecoration(
                      border: Border.all(color: Colors.grey),
                    ), //#change colore del bordo del singolo box
                    child: Row(
                      children: [
                        Expanded(
                          /*1*/
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              /*2*/
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.pushNamed(
                                        context,
                                        '/scheda',
                                        arguments: ScreenArgumentsSchedaParameters(value.authenticationToken, value.IDitem)
                                    );
                                  },
                                  child: ClipRRect(
                                      child: Container(
                                        decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: NetworkImage("${value.imagePath}"),
                                                fit: BoxFit.cover //#change zoomma l'immagine riempiendo la riga (quindi le parti dx e sx dell'immagine non si vedrà)
                                              //#fit: BoxFit.fill //#change stretcha l'immagine
                                            )
                                        ),
                                      )
                                  ),
                                ),
                              ),
                              Container(
                                //padding: const EdgeInsets.all(0), //#change spazio interno al box
                                child: Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text( "${value.title}",
                                    /*#change modifica lo stile del box
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),*/
                                  ),
                                ),
                              ),

                              /*#change: testo per sottotitolo
                              Text(
                                'sottotitolo',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),*/
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
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

class Category {
  Category({
    required this.authenticationToken,
    required this.IDitem,
    required this.item,
    required this.activities,
    this.title = '',
    this.imagePath = ''
  });

  int IDitem;
  Object item;
  String title;
  String imagePath;
  List activities;
  String authenticationToken;

  static List<Category> categoryList = <Category>[

  ];

  static List<Category> popularCourseList = <Category>[

  ];
}
