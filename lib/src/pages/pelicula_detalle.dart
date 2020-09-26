
import 'package:flutter/material.dart';
import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/peliculas_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class PeliculaDetalle extends StatelessWidget {

  const PeliculaDetalle({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Pelicula pelicula = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _crearAppBar(pelicula),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                _posterTitulo(pelicula, context),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _descripcion(pelicula),
                _crearCasting(pelicula)
              ]
            )
          )
        ],
      )
    );
  }

  Widget _crearAppBar(Pelicula pelicula) {
    return SliverAppBar(
      elevation: 2.0,
      backgroundColor: Colors.indigo,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Text(
          pelicula.title, 
          style: TextStyle(color: Colors.white, fontSize: 16.0), 
          ),
          background: FadeInImage(
            fadeInDuration: Duration(milliseconds: 150),
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/loading.gif'), 
            image: NetworkImage(pelicula.getBackgorundImg()
            )
          ),
      ),
    );
  }
  Widget _posterTitulo(Pelicula pelicula, BuildContext context){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        children: <Widget>[
          Hero(
            tag: pelicula.uniqueID,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
                child: Image(
                  image: NetworkImage(pelicula.getPosterImg()),
                  height: 150,
                ),
              ),
          ),
          SizedBox(width: 20),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(pelicula.title, style: Theme.of(context).textTheme.title, overflow: TextOverflow.ellipsis,),
                Text(pelicula.originalTitle, style: Theme.of(context).textTheme.subhead, overflow: TextOverflow.ellipsis,),
                Row(
                  children: <Widget>[
                    Icon(Icons.star_border),
                    Text(pelicula.voteAverage.toString(), style: Theme.of(context).textTheme.subhead)
                  ],
                )
              ],
            ))
        ],
      ),
    );
  }

  Widget _descripcion(Pelicula pelicula) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Text(pelicula.overview, textAlign: TextAlign.justify,),

    );
  }

  Widget _crearCasting(Pelicula pelicula) {
    final peliculaProvider = new PeliculasProviders();
    return FutureBuilder(
      future: peliculaProvider.getCast(pelicula.id.toString()),
      builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
        if (snapshot.hasData) {
          return _crearActoresPageView(snapshot.data);
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _crearActoresPageView(List<Actor> actores) {
    return SizedBox(
      height: 200,
      child: PageView.builder(
        pageSnapping: false,
        itemCount: actores.length,
        controller: PageController(
          viewportFraction: 0.3,
          initialPage: 1
        ),
        itemBuilder: (context, i) {
          return _actorTarjeta(actores[i]);
        },
      ),
    );
  }

  Widget _actorTarjeta(Actor actor) {
    return Container(
      child: Column(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
              child: FadeInImage(
                fit: BoxFit.cover,
                height: 150,
                placeholder: AssetImage('assets/no-image.jpg'), 
                image: NetworkImage(actor.getFoto())),
          ),
          Text(actor.name, overflow: TextOverflow.ellipsis,)
        ],
      ),
    );
  }
}