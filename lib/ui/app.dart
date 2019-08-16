import 'package:cooking_flutter/utils/app_colors.dart';
import 'package:cooking_flutter/utils/app_images.dart';
import 'package:cooking_flutter/utils/app_strings.dart';
import 'package:flutter/material.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _Home(),
    );
  }
}

class _Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      drawer: _buildDrawer(),
    );
  }

  Widget _buildAppBar() {
    return AppBar(
      title: Text("Cooking"),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
        child: Column(
      children: <Widget>[
        DrawerHeader(
          padding: EdgeInsets.zero,
          child: Image.asset(
            AppImages.drawer,
            height: 100.0,
            width: double.infinity,
            fit: BoxFit.cover,
            alignment: Alignment.center,
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
        )
      ],
    ));
  }

  void _onFavoriteClick() {}

  void _onSearchClick() {}
}
