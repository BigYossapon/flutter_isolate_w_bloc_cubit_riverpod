import 'dart:isolate';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/iso_bloc.dart';
import 'cubit/iso_cubit.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //Isolate.spawn
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Isolates',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => IsoBloc()),
          BlocProvider(create: (_) => IsoCubit()),
        ],
        child: MyHomePage(),
      ),
    );
  }
}
