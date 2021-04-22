import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_detector/modules/detector/presentation/detector_cubit.dart';
import 'package:language_detector/modules/detector/presentation/detector_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Language Detector',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: BlocProvider(
        create: (_) => DetectorCubit(),
        child: DetectorPage(),
      ),
    );
  }
}
