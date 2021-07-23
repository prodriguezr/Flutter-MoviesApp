import 'package:flutter/material.dart';
import 'package:movies_app/search/search_delegate.dart';
import 'package:provider/provider.dart';

import 'package:movies_app/widgets/widgets.dart';
import 'package:movies_app/providers/movies_provider.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Movies on Cinema\'s'),
        elevation: 0,
        actions: [
          IconButton(
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
              icon: Icon(Icons.search_outlined))
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Main Cards
            CardSwipper(movies: moviesProvider.playingNowMovies),
            // Movie Slider
            MovieSlider(
              movies: moviesProvider.popularMovies,
              title: 'Popular Movies',
              onNextPage: moviesProvider.getPopularMovies,
            ),
          ],
        ),
      ),
    );
  }
}
