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

class AddToFavoriteRecipeDetail extends RecipeDetailEvent {
  final Recipe recipe;

  AddToFavoriteRecipeDetail({@required this.recipe});
}

class RemoveFromFavoriteRecipeDetail extends RecipeDetailEvent {
  final Recipe recipe;

  RemoveFromFavoriteRecipeDetail({@required this.recipe});
}

abstract class RecipeDetailState {}

class RecipeDetailEmpty extends RecipeDetailState {}

class RecipeDetailLoading extends RecipeDetailState {}

class RecipeDetailLoaded extends RecipeDetailState {
  final Recipe recipe;

  RecipeDetailLoaded({@required this.recipe});
}

class RecipeDetailError extends RecipeDetailState {}

class RecipeDetailAddToFavorite extends RecipeDetailState {}

class RecipeDetailRemoveFromFavorite extends RecipeDetailState {}

class RecipeDetailBloc extends Bloc<RecipeDetailEvent, RecipeDetailState> {
  final RepositoryImpl repository;
  Recipe recipe;

  RecipeDetailBloc({@required this.repository, @required this.recipe});

  @override
  RecipeDetailState get initialState => RecipeDetailEmpty();

  @override
  Stream<RecipeDetailState> mapEventToState(RecipeDetailEvent event) async* {
    if (event is FetchRecipeDetail) {
      yield RecipeDetailLoading();

      try {
        final Recipe result = await repository.getRecipeById(recipe.id);
        recipe = result;
        recipe.totalComponent = recipe.components.length;
        recipe.totalStep = recipe.cookSteps.length;

        var rl = await repository.getRecipeFromLocal(recipe.id);
        if (rl != null) {
          recipe.isFavorite = true;
        } else {
          recipe.isFavorite = false;
        }

        yield RecipeDetailLoaded(recipe: recipe);
      } catch (_) {
        yield RecipeDetailError();
      }
    }

    if (event is RefreshRecipeDetail) {
      try {
        final Recipe result = await repository.getRecipeById(recipe.id);
        recipe = result;
        recipe.totalComponent = recipe.components.length;
        recipe.totalStep = recipe.cookSteps.length;

        var rl = await repository.getRecipeFromLocal(recipe.id);
        if (rl != null) {
          recipe.isFavorite = true;
        } else {
          recipe.isFavorite = false;
        }

        yield RecipeDetailLoaded(recipe: recipe);
      } catch (_) {
        yield RecipeDetailError();
      }
    }

    if (event is AddToFavoriteRecipeDetail) {
      await repository.insertRecipe(recipe);
      recipe.isFavorite = true;
      yield RecipeDetailAddToFavorite();
    }

    if (event is RemoveFromFavoriteRecipeDetail) {
      await repository.deleteRecipe(recipe);
      recipe.isFavorite = false;
      yield RecipeDetailRemoveFromFavorite();
    }
  }
}
