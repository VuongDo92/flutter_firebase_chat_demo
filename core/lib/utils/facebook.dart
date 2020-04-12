import 'package:http/http.dart' as http;
import 'dart:convert' as JSON;

Future<String> getFacebookEmailFromToken(String token) async {
  final graphResponse = await http.get(
      'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
  Map<String, dynamic> profile = JSON.jsonDecode(graphResponse.body);
  return profile['email'];
}
