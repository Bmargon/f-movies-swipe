import 'package:flutter/material.dart';
import 'package:peliculas/src/models/peliculas_model.dart';
import 'package:peliculas/src/providers/peliculas_provider.dart';

class SearchData extends SearchDelegate {

  final peliculasProvider = new PeliculasProviders();

  String seleccion = '';
  final peliculas = [
    'spiderman', 'superman', 'spiderman', 'superman', 'spiderman', 'superman', 'spiderman', 'superman'
  ];
  final peliculasRecientes = [
    'spiderman', 'superman'
  ];

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear), 
        onPressed: () {
          query = '';
        }
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // Icono a la izquierda del appBar
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow, 
        progress: transitionAnimation
      ), 
      onPressed: () {
        close(context, null);
      }
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // Builder que crea los resultados
    return Center(
      child: Container(
        height: 100,
        width: 100,
        color: Colors.blueAccent,
        child: Text(seleccion),
      ),
    );
  }

  // @override
  // Widget buildSuggestions(BuildContext context) {
  //   final listaBusqueda = (query.isEmpty) ? peliculasRecientes : peliculas.where((p) => p.toLowerCase().startsWith(query.toLowerCase())).toList();
  //   // Sugerencias que aparecen cuando la persona escribe
  //   return ListView.builder(
  //     itemCount: listaBusqueda.length,
  //     itemBuilder: (context, i) {
  //       return ListTile(
  //         leading: Icon(Icons.movie),
  //         title: Text(listaBusqueda[i]),
  //         onTap: () {
  //           seleccion = listaBusqueda[i];
  //           showResults(context);
  //         },
  //       );
  //     },
  //   );
  // }
  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) return Container();
    return FutureBuilder(
      future: peliculasProvider.buscarPelicula(query),
      builder: (BuildContext context, AsyncSnapshot<List<Pelicula>> snapshot){
        if (snapshot.hasData){
          final peliculas = snapshot.data;
          return ListView(
            children: peliculas.map((pelicula) {
              return ListTile(
                leading: FadeInImage(
                  width: 50,
                  fit: BoxFit.contain,
                  placeholder: AssetImage('assets/no-image.jpg'), 
                  image: NetworkImage(pelicula.getPosterImg())
                ),
                title: Text(pelicula.title),
                subtitle: Text(pelicula.originalTitle),
                onTap: () {
                  pelicula.uniqueID = '';
                  Navigator.pushNamed(context, 'detalle', arguments: pelicula);
                  close(context, null);
                }
              );
            }).toList()
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
    );
  }

}