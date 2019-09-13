import 'dart:math';

import 'package:cooking_flutter/data/model/category.dart';
import 'package:cooking_flutter/ui/home/home_bloc.dart';
import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_images.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final homeBloc = BlocProvider.of<HomeBloc>(context);
    homeBloc.dispatch(FetchHome());

    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(homeBloc),
      body: _buildBody(homeBloc),
    );
  }

  Widget _buildBody(HomeBloc homeBloc) {
    return BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
      if (state is HomeLoaded) {
        final categories = state.categories;

        return GridView.count(
          crossAxisCount: 2,
          children: List.generate(categories.length, (index) {
            return _buildItemCategory(categories, index);
          }),
        );
      }
      if (state is HomeError) {
        return Center(
          child: Text("Error"),
        );
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    });
  }

  Widget _buildItemCategory(List<Category> categories, int index) {
    final category = categories[index];

    final widthScreen = MediaQuery.of(context).size.width;
    final space = 4.0;

    final widthItem = widthScreen / 2 - space * 4;

    final paddingLeft = index % 2 != 0 ? space / 2 : space;
    final paddingRight = index % 2 == 0 ? space / 2 : space;
    final paddingTop = space;
    final paddingBottom = index == (categories.length - 1) ? space : 0.0;

    return Padding(
      padding: EdgeInsets.only(
          top: paddingTop,
          bottom: paddingBottom,
          left: paddingLeft,
          right: paddingRight),
      child: Container(
        width: widthItem,
        height: widthItem,
        decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.all(Radius.circular(8.0))),
        child: Stack(
          children: <Widget>[Text(category.name)],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text(AppStrings.title_toolbar_categories),
      backgroundColor: AppColors.colorPrimary,
    );
  }

  Widget _buildDrawer(HomeBloc homeBloc) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: Image.asset(
              AppImages.drawer,
              height: 140.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          ListTile(
            title: Text(AppStrings.title_favorite),
            leading: Icon(
              Icons.favorite,
              color: AppColors.colorPrimary,
            ),
            onTap: _onFavoriteClick,
          ),
          ListTile(
            title: Text(AppStrings.title_search),
            leading: Icon(
              Icons.search,
              color: AppColors.colorPrimary,
            ),
            onTap: _onSearchClick,
          ),
          Container(
            height: 1.0,
            color: AppColors.color_gray_400,
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, left: 16.0),
            child: Text(
              AppStrings.title_categories.toUpperCase(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0,
                  color: AppColors.color_gray_600),
            ),
          ),
          Expanded(child:
              BlocBuilder<HomeBloc, HomeState>(builder: (context, state) {
            if (state is HomeLoaded) {
              final categories = state.categories;

              return ListView.separated(
                  padding: EdgeInsets.only(top: 8.0),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 8.0, right: 8.0),
                            child: Icon(
                              Icons.label,
                              color: AppColors.colorAccent,
                            ),
                          ),
                          Expanded(
                            child: Text(categories[index].name),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => Divider(
                        color: AppColors.color_gray_600,
                      ),
                  itemCount: categories.length);
            }
            if (state is HomeError) {
              return Center(
                child: Text("Error"),
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          })),
          ListTile(
            title: Text(AppStrings.title_rate_me),
            leading: Icon(
              Icons.thumb_up,
              color: AppColors.colorPrimary,
            ),
            onTap: _onRateMeClick,
          ),
          ListTile(
            title: Text(AppStrings.title_feedback),
            leading: Icon(
              Icons.feedback,
              color: AppColors.colorPrimary,
            ),
            onTap: _onFeedbackClick,
          ),
        ],
      ),
    );
  }

  void _onFavoriteClick() {}

  void _onSearchClick() {}

  void _onRateMeClick() {}

  void _onFeedbackClick() {}
}
