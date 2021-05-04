import 'package:language_detector/modules/detector/domain/entities/language.dart';

class LanguageModel extends Language {
  LanguageModel({required String name}) : super(name: name);

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }

  factory LanguageModel.fromJson(Map<String, dynamic> json) {
    return LanguageModel(name: json['name']);
  }
}
