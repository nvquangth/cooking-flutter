import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'dart:async';

abstract class RecipeDetailEvent {}

class FetchRecipeDetail extends RecipeDetailEvent {
  final String recipeId;

  FetchRecipeDetail({@required this.recipeId});
}

class RefreshRecipeDetail extends RecipeDetailEvent {
  final String recipeId;

  RefreshRecipeDetail({@required this.recipeId});
}

abstract class RecipeDetailState {}

class RecipeDetailEmpty extends RecipeDetailState {}

class RecipeDetailLoading extends RecipeDetailState {}

class RecipeDetailLoaded extends RecipeDetailState {
  final Recipe recipe;

  RecipeDetailLoaded({@required this.recipe});
}

class RecipeDetailError extends RecipeDetailState {}

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  final RepositoryImpl repository;
  final Recipe recipe;

  RecipeDetailBloc({@required this.repository, @required this.recipe});

  @override
  RecipeDetailState get initialState => RecipeDetailEmpty();

  @override
  Stream<RecipeDetailState> mapEventToState(RecipeDetailEvent event) async* {
    if (event is FetchRecipeDetail) {
      yield RecipeDetailLoading();
    }

    try {
      final Recipe result = await repository.getRecipeById(recipe.id);
      yield RecipeDetailLoaded(recipe: result);
    } catch (_) {
      yield RecipeDetailError();
    }
  }
}
