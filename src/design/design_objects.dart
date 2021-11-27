import 'package:baseappahome/src/config/app_config.dart';
import 'package:flutter/material.dart';

import '../../main.dart';

class DesignObjects {

  Widget horizontalScrollSection(Section section) {

    String sectionTitle = section.sectionTitle;

    return Column(
      children: <Widget>[
        Container(
            child: Text(sectionTitle) //# titolo della sezione
        ),
        Container(
          // #altezza del contenitore della Card.
          // E' lo spazio che contiene immagini e testi che scrollano orizzontalmente
          // Dovrebbe essere uguale all'altezza dell'immagine
          // ma si può adattare per inserire un testo o altre immagini sotto
          height: 150.0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: section.dataList.length, //# numero delle Card presenti
            itemBuilder: (context, index) {
              String itemtitle = section.dataList[index].title;
              String imagePath = section.dataList[index].imagePath;
              String excerpt = section.dataList[index].excerpt;
              return  GestureDetector(
                child: Card( //# questo è il box cliccabile
                  elevation: 5.0, //#change grandezza dell'ombra dietro la Card
                  child: Row( //# questa riga contiene le due colonne (una per l'immagine e una per i testi)
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(imagePath),
                                  fit: BoxFit.cover //#change zoomma l'immagine riempiendo la riga (quindi le parti dx e sx dell'immagine non si vedrà)
                                //#fit: BoxFit.fill //#change stretcha l'immagine
                              ),
                            ),
                            height: MediaQuery.of(context).size.width / 3,
                            width: MediaQuery.of(context).size.width / 3,
                            alignment: Alignment.center,
                            //#change child: new Text('Item $index' + itemtitle), text over the image
                          ),
                          // Text(itemtitle), //# change per inserire un testo sotto l'immagine, adattamdo l'altezza del container
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(itemtitle),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                              width: 200, //#impostare questa larghezza altrimenti non va a capo mai
                              child: Text(excerpt + itemtitle),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print(index);
                  Navigator.pushNamed(
                      context,
                      '/scheda',
                      arguments: ScreenArgumentsSchedaParameters('asdasdasd', index) //#todo
                  );
                },
              );
            },
          ),
        ),
        //new SizedBox(height: 20.0),
      ],
    );

  }

  Widget verticalScrollSection(Section section) {

    String sectionTitle = section.sectionTitle;

    return Column(
      children: <Widget>[
        Container(
            child: Text(sectionTitle) //# titolo della sezione
        ),
        Container(
          // #altezza del contenitore della Card.
          // E' lo spazio che contiene immagini e testi che scrollano orizzontalmente
          // Dovrebbe essere uguale all'altezza dell'immagine
          // ma si può adattare per inserire un testo o altre immagini sotto
          height: 150.0,
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: section.dataList.length, //# numero delle Card presenti
            itemBuilder: (context, index) {
              String itemtitle = section.dataList[index].title;
              String imagePath = section.dataList[index].imagePath;
              String excerpt = section.dataList[index].excerpt;
              return  GestureDetector(
                child: Card( //# questo è il box cliccabile
                  elevation: 5.0, //#change grandezza dell'ombra dietro la Card
                  child: Row( //# questa riga contiene le due colonne (una per l'immagine e una per i testi)
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(imagePath),
                                  fit: BoxFit.cover //#change zoomma l'immagine riempiendo la riga (quindi le parti dx e sx dell'immagine non si vedrà)
                                //#fit: BoxFit.fill //#change stretcha l'immagine
                              ),
                            ),
                            height: MediaQuery.of(context).size.width / 3,
                            width: MediaQuery.of(context).size.width / 3,
                            alignment: Alignment.center,
                            //#change child: new Text('Item $index' + itemtitle), text over the image
                          ),
                          // Text(itemtitle), //# change per inserire un testo sotto l'immagine, adattamdo l'altezza del container
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(itemtitle),
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                            child: Container(
                              width: 200, //#impostare questa larghezza altrimenti non va a capo mai
                              child: Text(excerpt + itemtitle),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  print(index);
                  Navigator.pushNamed(
                      context,
                      '/scheda',
                      arguments: ScreenArgumentsSchedaParameters('asdasdasd', index) //#todo
                  );
                },
              );
            },
          ),
        ),
        //new SizedBox(height: 20.0),
      ],
    );

  }

  Widget get_drawer(context, _authtokenlogin_saved){
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: AppConfig.applabels['menu']['header']['bgcolor'],
            ),
            child: Text(AppConfig.applabels['menu']['header']['labelText']),
          ),
          ListTile(
            title: Text(AppConfig.applabels['menu']['items']['item1']['labelText']),
            onTap: () {
              // Update the state of the app
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text(AppConfig.applabels['menu']['logout']['labelText']),
            onTap: () {
              Navigator.pushNamed(
                  context,
                  '/signout_http',
                  arguments: ScreenArgumentsLogoutFormParameters(
                      _authtokenlogin_saved
                  )
              );
            },
          ),
        ],
      ),
    );
  }
}

class Section {
  Section({
    required this.sectionTitle,
    required this.dataList
  });

  String sectionTitle;
  List<ContentBox> dataList = [];
}

class Sections {
  Sections({
    required this.section1,
    required this.section2
  });

  Section section1;
  Section section2;
}

class ContentBox {
  ContentBox({
    required this.authenticationToken,
    required this.IDitem,
    required this.item,
    this.title = '',
    this.excerpt = '',
    this.imagePath = ''
  });

  int IDitem;
  Object item;
  String title;
  String excerpt;
  String imagePath;
  String authenticationToken;
}