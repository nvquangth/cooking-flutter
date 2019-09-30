import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class SearchEvent {}

class ClearQuerySearch extends SearchEvent {}

class ExecuteSearch extends SearchEvent {
  final String q;

  ExecuteSearch({this.q});
}

class RefreshSearch extends SearchEvent {
  final String q;

  RefreshSearch({this.q});
}

abstract class SearchState {}

class SearchInit extends SearchState {}

class SearchEmpty extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Recipe> recipes;

  SearchLoaded({this.recipes});
}

class QueryEmpty extends SearchState {}

class SearchError extends SearchState {}

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final RepositoryImpl repository;
  TextEditingController textEditingController = TextEditingController();
  String q;

  SearchBloc({@required this.repository});

  @override
  SearchState get initialState => SearchInit();

  @override
  Stream<SearchState> mapEventToState(SearchEvent event) async* {
    if (event is ClearQuerySearch) {
      textEditingController.clear();
      return;
    }

    if (event is ExecuteSearch) {
      q = event.q;

      yield SearchLoading();

      try {
        final List<Recipe> recipes = await repository.getRecipesByName(q);

        for (final recipe in recipes) {
          final rl = await repository.getRecipeFromLocal(recipe.id);

          if (rl != null) {
            recipe.isFavorite = true;
          } else {
            recipe.isFavorite = false;
          }
        }

        if (recipes == null || recipes.length == 0) {
          yield SearchEmpty();
        } else {
          yield SearchLoaded(recipes: recipes);
        }
      } catch (_) {
        yield SearchError();
      }
    }

    if (event is RefreshSearch) {
      q = event.q;

      try {
        final List<Recipe> recipes = await repository.getRecipesByName(event.q);

        for (final recipe in recipes) {
          final rl = await repository.getRecipeFromLocal(recipe.id);

          if (rl != null) {
            recipe.isFavorite = true;
          } else {
            recipe.isFavorite = false;
          }
        }

        if (recipes == null || recipes.length == 0) {
          yield SearchEmpty();
        } else {
          yield SearchLoaded(recipes: recipes);
        }
      } catch (_) {
        yield SearchError();
      }
    }
  }

  bool _isValidQuery(String q) => q != null && q.trim().length > 0;
}
