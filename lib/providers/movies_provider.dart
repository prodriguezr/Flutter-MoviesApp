import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  String _apiKey = '1865f43a0549ca50d341dd9ab8b29f49';
  String _baseUrl = 'api.themoviedb.org';
  String _language = 'es-CL';

  List<Movie> playingNowMovies = [];
  List<Movie> popularMovies = [];

  int _popularPage = 0;

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
}
