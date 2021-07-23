import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/helpers/debouncer.dart';
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-CL';

  List<Movie> playingNowMovies = [];
  List<Movie> popularMovies = [];

  Map<int, List<Cast>> movieCast = {};

  int _popularPage = 0;

  final StreamController<List<Movie>> _streamController =
      new StreamController.broadcast();

  final debouncer = Debouncer(
    duration: Duration(milliseconds: 300),
  );

  Stream<List<Movie>> get suggestionStream => this._streamController.stream;

  MoviesProvider() {
    print('MoviesProvider initialized');

    this.getPlayingNowMovies();
    this.getPopularMovies();
  }

  Future<String> _getJsonData(String segment, {int page = 1}) async {
    final url = Uri.https(this._baseUrl, segment,
        {'api_key': _apiKey, 'language': _language, 'page': '$page'});

    final response = await http.get(url);

    return response.body;
  }

  getPlayingNowMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');

    final playingNowResponse = PlayingNowResponse.fromJson(jsonData);

    playingNowMovies = playingNowResponse.results;

    notifyListeners();
  }

  getPopularMovies() async {
    this._popularPage++;

    final jsonData =
        await _getJsonData('3/movie/popular', page: this._popularPage);

    final popularResponse = PopularResponse.fromJson(jsonData);

    popularMovies = [...popularMovies, ...popularResponse.results];

    notifyListeners();
  }

  Future<List<Cast>> getMovieCredits({required int movieId}) async {
    if (movieCast.containsKey(movieId)) {
      return movieCast[movieId]!;
    }

    final jsonData =
        await _getJsonData('3/movie/$movieId/credits', page: this._popularPage);

    final castResponse = CastResponse.fromJson(jsonData);

    movieCast[movieId] = castResponse.cast;

    return castResponse.cast;
  }

  Future<List<Movie>> searchMovies({required String query}) async {
    final url = Uri.https(this._baseUrl, '3/search/movie',
        {'api_key': _apiKey, 'language': _language, 'query': query});

    final response = await http.get(url);

    final movieResponse = SearchMovieResponse.fromJson(response.body);

    return movieResponse.results;
  }

  void getSuggestionByQuery(String query) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      this._streamController.add(await searchMovies(query: value));
    };

    final timer = Timer.periodic(Duration(milliseconds: 300), (_) {
      debouncer.value = query;
    });

    Future.delayed(Duration(milliseconds: 301)).then((_) => timer.cancel());
  }
}
