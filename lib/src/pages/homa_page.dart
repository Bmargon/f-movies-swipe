import 'package:flutter/material.dart';
import 'package:peliculas/src/pages/widgets/card_swiper_widget.dart';
import 'package:peliculas/src/pages/widgets/movie_horizontal.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';
import 'package:peliculas/src/search/search_delegate.dart';

class HomePage extends StatelessWidget {
  
  final peliculasProviders = new PeliculasProviders();
  
  @override
  Widget build(BuildContext context) {
    peliculasProviders.popularesCines();
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text('Peliculas en cine'),
        backgroundColor: Colors.indigoAccent,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.search), 
            onPressed: () {
              showSearch( 
                context: context, 
                delegate: SearchData());
            }) 
        ],
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            _swipeCards(),
            _footer(context)
          ],
        ),
      ),
    );
  }

  Widget _swipeCards () {
    return FutureBuilder(
      future: peliculasProviders.getCines(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData ) {
          return CardSwiper(
            peliculas: snapshot.data
            );
        } else {
          return Container(
            height: 400.00,
            child: Center(
              child: CircularProgressIndicator()
              )
            );
        }
      },
    );
  }

  Widget _footer(BuildContext context) {

    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(left: 20),
            child: Text('Peliculas Populares', 
            style: Theme.of(context).textTheme.subhead
          )),
          SizedBox(height: 5.0),
          StreamBuilder(
            stream: peliculasProviders.popularesStream,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData) {
                return MovieHorizontal(peliculas: snapshot.data, siguientePagina: peliculasProviders.popularesCines);
              } else {
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }
}