import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:language_detector/modules/core/error/exception.dart';
import 'package:language_detector/modules/core/http/urls.dart';
import 'package:language_detector/modules/detector/data/models/language_model.dart';
import 'package:language_detector/modules/detector/domain/entities/language.dart';

abstract class DetectorRemoteDatasource {
  Future<Language> getLanguage(String input);
}

class DetectorRemoteDatasourceImpl implements DetectorRemoteDatasource {
  final http.Client client;

  DetectorRemoteDatasourceImpl({required this.client});

  @override
  Future<Language> getLanguage(String input) async {
    final response = await client.get(
      Uri.parse('${Urls.detect}&q=$input'),
      headers: {
        'Content-Type': 'application/json',
      },
    );
    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      return LanguageModel.fromJson(json.decode(response.body));
    } else {
      throw ServerException();
    }
  }
}
