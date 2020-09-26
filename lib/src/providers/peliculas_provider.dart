import 'dart:async';
import 'dart:convert';

import 'package:peliculas/src/models/actores_model.dart';
import 'package:peliculas/src/models/peliculas_model.dart';
import 'package:http/http.dart' as http;

class PeliculasProviders {
  String _apiKey = '71835b4bf5ddd92c1591bf74757a1937';
  String _url = 'api.themoviedb.org';
  String _lenguage = 'es-ES';
  bool _cargando = false;

  int _pagePopulares = 0;

  // Stream

  List<Pelicula> _populares = new List();

  final _popularesStreamController = StreamController<List<Pelicula>>.broadcast();

  Function(List<Pelicula>) get popularesSink => _popularesStreamController.sink.add;
  Stream<List<Pelicula>> get popularesStream => _popularesStreamController.stream;

  void disposeStreams() {
    _popularesStreamController?.close();
  }

  Future<List<Pelicula>> _respuestaProcess(Uri url) async {
    final respuesta = await http.get(url);
    final decodedData = json.decode(respuesta.body);
    final peliculas = new Peliculas.fromJsonList(decodedData['results']);
    return peliculas.items;
  }

  Future<List<Pelicula>> getCines() async {
    final url = Uri.https(_url, '3/movie/now_playing', {
      'api_key': _apiKey,
      'lenguage': _lenguage
    });
    return await _respuestaProcess(url);

  }

  Future<List<Pelicula>> popularesCines() async {

    if (_cargando) return [];
    _cargando = true;
    _pagePopulares++;

    final url = Uri.https(_url, '3/movie/popular', {
      'api_key': _apiKey,
      'lenguage': _lenguage,
      'page': _pagePopulares.toString()
    });


    final resp = await _respuestaProcess(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;

    return resp;
  }

  Future<List<Actor>>getCast(String peliId) async {
    final url = Uri.https(_url, '3/movie/$peliId/credits', {
      'api_key': _apiKey,
      'lenguage': _lenguage,
    });
    print(url);
    final resp = await http.get(url);
    final decodedData = json.decode(resp.body);
    final cast = new Actores.fromjsonList(decodedData['cast']);
    return cast.actores;
  }



   Future<List<Pelicula>> buscarPelicula(String query) async {


    final url = Uri.https(_url, '3/search/movie/', {
      'api_key': _apiKey,
      'lenguage': _lenguage,
      'query': query
    });


    final resp = await _respuestaProcess(url);
    _populares.addAll(resp);
    popularesSink(_populares);
    _cargando = false;

    return resp;
  }
}
// https://api.themoviedb.org/3/movie/now_playing?api_key=71835b4bf5ddd92c1591bf74757a1937&language=en-US&page=1