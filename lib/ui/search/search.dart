import 'dart:async';

import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:cooking_flutter/ui/recipedetail/recipe_detail.dart';
import 'package:cooking_flutter/ui/recipedetail/recipe_detail_bloc.dart';
import 'package:cooking_flutter/ui/search/search_bloc.dart';
import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_images.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Search extends StatefulWidget {
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  SearchBloc _bloc;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<SearchBloc>(context);
    _refreshCompleter = Completer<void>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _bloc.textEditingController,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
              border: InputBorder.none,
              hintText: AppStrings.hint_search,
              hintStyle: TextStyle(color: Colors.white)),
          onSubmitted: (String q) {
            _bloc.dispatch(ExecuteSearch(q: q));
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              _bloc.dispatch(ClearQuerySearch());
            },
          )
        ],
        backgroundColor: AppColors.colorPrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocListener<SearchBloc, SearchState>(
      listener: (context, state) {
        if (state is SearchLoaded || state is SearchError) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer();
        }
      },
      child: BlocBuilder<SearchBloc, SearchState>(
        builder: (context, state) {
          if (state is SearchLoaded) {
            final recipes = state.recipes;

            return RefreshIndicator(
              child: ListView.builder(
                  itemCount: recipes.length,
                  itemBuilder: (context, index) {
                    return _buildItemRecipe(recipes, index);
                  }),
              onRefresh: () {
                _bloc.dispatch(RefreshSearch(q: _bloc.q));
                return _refreshCompleter.future;
              },
            );
          }

          if (state is SearchError) {
            return RefreshIndicator(
              child: ListView(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 16.0, bottom: 8.0, left: 64.0, right: 64.0),
                        child: Text(
                          AppStrings.msg_no_data_refresh,
                          textAlign: TextAlign.center,
                          style: TextStyle(),
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          _bloc.dispatch(ExecuteSearch(q: _bloc.q));
                        },
                        child: Text(AppStrings.title_reload_data),
                      )
                    ],
                  )
                ],
              ),
              onRefresh: () {
                _bloc.dispatch(ExecuteSearch(q: _bloc.q));
                return _refreshCompleter.future;
              },
            );
          }

          if (state is SearchLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (state is SearchEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  AppStrings.msg_no_data_search,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return Container();
        },
      ),
    );
  }

  Widget _buildItemRecipe(List<Recipe> recipes, int index) {
    final recipe = recipes[index];

    return GestureDetector(
      onTap: () {
        _onItemRecipeClick(recipe);
      },
      child: Container(
        height: 200.0,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            FadeInImage.assetNetwork(
              placeholder: AppImages.default_image_large,
              image: recipe.img,
              fit: BoxFit.cover,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 72.0,
                color: AppColors.color_transparent_48,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 8.0, bottom: 8.0, right: 8.0, top: 8.0),
                      child: Text(
                        recipe.name,
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                        maxLines: 1,
                      ),
                    ),
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                          child: Icon(
                            Icons.alarm,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${recipe.time} phút',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 4.0),
                          child: Icon(
                            Icons.group,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${recipe.serving} người',
                          style: TextStyle(color: Colors.white),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 4.0),
                          child: Icon(
                            Icons.list,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          '${recipe.totalComponent} nguyên liệu',
                          style: TextStyle(color: Colors.white),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: recipe.isFavorite
                    ? Icon(
                        Icons.favorite,
                        color: Colors.white,
                      )
                    : Container(),
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onItemRecipeClick(Recipe recipe) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => BlocProvider(
              builder: (context) => RecipeDetailBloc(
                  repository: RepositoryImpl(), recipe: recipe),
              child: RecipeDetail(),
            )));
  }
}
