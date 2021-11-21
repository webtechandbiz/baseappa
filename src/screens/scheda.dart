import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import '../../main.dart'; /*fetch data*/

/*fetch data */
Future<Datascheda> fetchDatascheda(String authenticationToken, int IDitem) async {
  Map<String, String> headers = {"Content-type": "application/json; charset=UTF-8"};
  String json = '{"authenticationToken": "${authenticationToken}", "post_id": "${IDitem}"}';
  final response = await post(Uri.parse('[ws-scheda-dettaglio]'), headers: headers, body: json);

  if (response.statusCode == 200) {
    return Datascheda.fromJson(jsonDecode(response.body));
  } else {
    throw Exception('Failed to load scheda');
  }
}

class FavoriteWidget extends StatefulWidget {
  const FavoriteWidget({Key? key}) : super(key: key);

  @override
  _FavoriteWidgetState createState() => _FavoriteWidgetState();
}
class _FavoriteWidgetState extends State<FavoriteWidget> {
  bool _isFavorited = true;
  int _favoriteCount = 41;

  // ···
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(0),
          child: IconButton(
            padding: const EdgeInsets.all(0),
            alignment: Alignment.centerRight,
            icon: (_isFavorited
                ? const Icon(Icons.star)
                : const Icon(Icons.star_border)),
            color: Colors.red[500],
            onPressed: _toggleFavorite,
          ),
        ),
        SizedBox(
          width: 18,
          child: SizedBox(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }

  void _toggleFavorite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }
}

/*fetch data*/
class Datascheda {
  bool? success;
  final String? authenticationToken;
  final String title;
  final int id;
  final String description;
  final String imgurl;

  Datascheda({
    required this.authenticationToken,
    required this.title,
    required this.id,
    required this.description,
    required this.imgurl
  });

  factory Datascheda.fromJson(Map<String, dynamic> json) {
    if(json['id'] == null){json['id'] = 0;}
    if(json['userId'] == null){json['userId'] = 0;}

    return Datascheda(
      authenticationToken: json['authenticationToken'],
      title: json['title'],
      id: json['id'],
      description: json['description'],
      imgurl: json['imgurl']
    );
  }
}

class Scheda extends StatefulWidget {
  const Scheda({Key? key}) : super(key: key);

  @override
  _SchedaState createState() => _SchedaState();
}

class _SchedaState extends State<Scheda> {
  late Future<Datascheda> futureDatascheda;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final schedaArgs = ModalRoute.of(context)!.settings.arguments as ScreenArgumentsSchedaParameters;
    futureDatascheda = fetchDatascheda(schedaArgs.authenticationToken, schedaArgs.id);
    /* //#step3 */
    Color color = Theme.of(context).primaryColor;
    /* //#step3 -- */

    return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.blue, //#change colore (del titolo)
            title: Text(''), //#change titolo sopra campi di login
          ),

          body: FutureBuilder<Datascheda>(
            future: futureDatascheda,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                /* //#step2 */
                Widget titleSection = Container(
                  padding: EdgeInsets.fromLTRB(10, 20, 10, 10),
                  child: Row(
                    children: [
                      Expanded(
                        /*1*/
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /*2*/
                            Container(
                              //padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                              child: Text(
                                snapshot.data!.title,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            /* #change sottotitolo
                            Text(
                              '',
                              style: TextStyle(
                                color: Colors.grey[500],
                              ),
                            ),*/
                          ],
                        ),
                      ),
                      /*3*/
                      const FavoriteWidget(), //#step4: mettiamo il nuovo widget al posto dell'icona statica che avevamo nelle righe appena precedenti a questa
                    ],
                  ),
                );
                /* //#step2 -- */

                /* //#step2 */
                Widget textSection = Padding(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
                    child: Text(
                      snapshot.data!.description,
                      softWrap: true,
                    )
                );
                /* //#step2 -- */

                /* //#step2 */
                Widget imageSection =
                  Image.network(
                    snapshot.data!.imgurl,
                    fit: BoxFit.cover,
                  );
                /* //#step2 -- */

                return ListView( //#step2
                    children: [ //#step2
                      imageSection, //#step2
                      titleSection, //#step2
                      textSection, //#step4
                    ] //#step2
                );
                //return Text(snapshot.data!.title);
              } else if (snapshot.hasError) {
                return Text('${snapshot.error}');
              }

              // By default, show a loading spinner.
              return const CircularProgressIndicator();
            },
          )//#step2

    );
  }

}
