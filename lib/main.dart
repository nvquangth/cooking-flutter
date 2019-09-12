import 'package:cooking_flutter/data/repository/repository.dart';
import 'package:cooking_flutter/ui/home/home.dart';
import 'package:cooking_flutter/ui/home/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cooking',
      home: BlocProvider(
        builder: (context) => HomeBloc(repository: RepositoryImpl()),
        child: Home(),
      ),
    );
  }
}
