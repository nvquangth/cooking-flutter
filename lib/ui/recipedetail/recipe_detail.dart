import 'dart:async';

import 'package:cooking_flutter/data/model/recipe.dart';
import 'package:cooking_flutter/ui/recipedetail/recipe_detail_bloc.dart';
import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:toast/toast.dart';

class RecipeDetail extends StatefulWidget {
  @override
  State<RecipeDetail> createState() => _RecipeDetailState();
}

class _RecipeDetailState extends State<RecipeDetail> {
  RecipeDetailBloc _bloc;
  Recipe _recipe;
  Completer<void> _refreshCompleter;

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<RecipeDetailBloc>(context);
    _recipe = _bloc.recipe;
    _refreshCompleter = Completer<void>();

    _bloc.dispatch(FetchRecipeDetail(recipeId: _recipe.id));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_recipe.name),
        backgroundColor: AppColors.colorPrimary,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return BlocListener<RecipeDetailBloc, RecipeDetailState>(
      listener: (context, state) {
        if (state is RecipeDetailLoaded || state is RecipeDetailError) {
          _refreshCompleter?.complete();
          _refreshCompleter = Completer<void>();
        }
      },
      child: BlocBuilder<RecipeDetailBloc, RecipeDetailState>(
        builder: (context, state) {
          if (state is RecipeDetailLoaded ||
              state is RecipeDetailAddToFavorite) {
            if (state is RecipeDetailLoaded) {
              _recipe = state.recipe;
            }

            return RefreshIndicator(
              child: ListView(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, right: 4.0),
                          child: Icon(
                            Icons.alarm,
                            color: AppColors.colorAccent,
                          ),
                        ),
                        Text(
                          '${_recipe.time} phút',
                          style: TextStyle(color: AppColors.colorAccent),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 4.0),
                          child: Icon(
                            Icons.group,
                            color: AppColors.colorAccent,
                          ),
                        ),
                        Text(
                          '${_recipe.serving} người',
                          style: TextStyle(color: AppColors.colorAccent),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 16.0, right: 4.0),
                          child: Icon(
                            Icons.list,
                            color: AppColors.colorAccent,
                          ),
                        ),
                        Text(
                          '${_recipe.components.length} nguyên liệu',
                          style: TextStyle(color: AppColors.colorAccent),
                        )
                      ],
                    ),
                  ),
                  Container(
                      height: 200.0,
                      child: Stack(
                        fit: StackFit.expand,
                        children: <Widget>[
                          Image.network(
                            _recipe.img,
                            fit: BoxFit.cover,
                          ),
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: GestureDetector(
                              onTap: _onFavoriteClick,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: AppColors.color_transparent_48,
                                      shape: BoxShape.circle),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(
                                      state is RecipeDetailAddToFavorite
                                          ? Icons.favorite
                                          : Icons.favorite_border,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      )),
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                            Text('NGUYÊN LIỆU (${_recipe.components.length})'),
                      ),
                      color: AppColors.color_gray_300),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              top: index == 0 ? 8.0 : 0.0,
                              bottom: index == _recipe.components.length - 1
                                  ? 8.0
                                  : 0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(left: 8.0, right: 8.0),
                                child: Icon(
                                  Icons.control_point,
                                  color: AppColors.colorAccent,
                                ),
                              ),
                              SizedBox(
                                child: Html(
                                  data: _recipe.components[index].quantity,
                                ),
                                width: 35.0,
                              ),
                              Text(
                                  '(${_recipe.components[index].unit}) ${_recipe.components[index].name}')
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: _recipe.components.length),
                  Container(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('BƯỚC LÀM (${_recipe.cookSteps.length})'),
                      ),
                      color: AppColors.color_gray_300),
                  ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Stack(
                                children: <Widget>[
                                  Icon(
                                    Icons.radio_button_unchecked,
                                    color: AppColors.colorAccent,
                                  ),
                                  Positioned(
                                    top: 4.0,
                                    left: 8.0,
                                    child: Text(
                                      '${index + 1}',
                                      style: TextStyle(
                                          color: AppColors.colorAccent),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                _recipe.cookSteps[index].des,
                                textAlign: TextAlign.justify,
                              ),
                            ))
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return Divider();
                      },
                      itemCount: _recipe.cookSteps.length)
                ],
              ),
              onRefresh: () {
                _bloc.dispatch(FetchRecipeDetail(
                  recipeId: _bloc.recipe.id,
                ));
                return _refreshCompleter.future;
              },
            );
          }

          if (state is RecipeDetailError) {
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
                          _bloc.dispatch(
                              FetchRecipeDetail(recipeId: _recipe.id));
                        },
                        child: Text(AppStrings.title_reload_data),
                      )
                    ],
                  )
                ],
              ),
              onRefresh: () {
                _bloc.dispatch(FetchRecipeDetail(recipeId: _recipe.id));
                return _refreshCompleter.future;
              },
            );
          }

          if (state is RecipeDetailLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return Container();
        },
      ),
    );
  }

  void _onFavoriteClick() {
    _bloc.dispatch(AddToFavoriteRecipeDetail(recipe: _recipe));
  }
}
