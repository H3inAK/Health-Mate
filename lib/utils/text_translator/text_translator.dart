import 'package:translator/translator.dart';

final translator = GoogleTranslator();

Future<String> translate(
    {required String text, String from = 'auto', String to = 'en'}) async {
  final result = await translator.translate(text, from: from, to: to);
  return result.text;
}
