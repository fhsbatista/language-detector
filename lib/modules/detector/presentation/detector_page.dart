import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:language_detector/modules/detector/presentation/detector_bloc.dart';

class DetectorPage extends StatefulWidget {
  @override
  _DetectorPageState createState() => _DetectorPageState();
}

class _DetectorPageState extends State<DetectorPage> {
  final _fieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<DetectorBloc>(context).stream.listen((event) {
      if (event is ErrorState) {
        final snackbar = SnackBar(content: Text(event.msg));
        ScaffoldMessenger.of(context).showSnackBar(snackbar);
      }
    });
  }

  @override
  void dispose() {
    _fieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Language detector'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<DetectorBloc, DetectorState>(
          builder: (context, state) => Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Type something to detect the language...',
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Builder(
                builder: (_) {
                  if (state is LoadingState) {
                    return CircularProgressIndicator();
                  } else {
                    return Container(
                      height: 50.0,
                      child: ElevatedButton(
                        onPressed: () {
                          BlocProvider.of<DetectorBloc>(context).add(
                            GetLanguageEvent(_fieldController.text),
                          );
                        },
                        child: Container(
                          height: 50.0,
                          width: 100,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10.0,
                            vertical: 5.0,
                          ),
                          child: Center(
                            child: state is LoadingState
                                ? Container(
                                    height: 20.0,
                                    width: 20.0,
                                    child: CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : Text(
                                    'Detect',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              const SizedBox(height: 20),
              if (state is LoadedState) Text('The language detected is ${state.language}')
            ],
          ),
        ),
      ),
    );
  }
}
