import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_detector/injection.dart';
import 'package:language_detector/modules/detector/presentation/detector_bloc.dart';
import 'package:language_detector/modules/detector/presentation/detector_page.dart';

import 'injection.dart' as di;

void main() async {
  await di.init();
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
        create: (_) => DetectorBloc(getLanguageUsecase: getIt()),
        child: DetectorPage(),
      ),
    );
  }
}
