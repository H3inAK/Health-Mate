import 'package:http/http.dart';

String httpErrorHandler(Response response) {
  String message = "Status : ${response.statusCode}\n";
  message += "Reason : ${response.reasonPhrase}";

  return message;
}
