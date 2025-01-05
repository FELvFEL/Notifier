import 'dart:convert';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getRequisites() async {
  Uri url = Uri.parse('https://flexlearn.ru/notifications/get_requisites');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}

Future<Map<String, dynamic>> sendNotification(Map<String, dynamic> payload) async {
  Uri url = Uri.parse('https://flexlearn.ru/notifications/send');
  final response = await http.post(
    url,
    headers: {
      'Content-Type': 'application/json',
    },
    body: json.encode(payload),
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Error: ${response.reasonPhrase}');
  }
}
