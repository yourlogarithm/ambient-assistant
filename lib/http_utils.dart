import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class HttpUtils {
  static String hostname = "http://192.168.109.123:80";

  static Future<http.Response> postRequest(Map<String, String> body, String endpoint) {
    return http.post(
      Uri.parse(hostname + endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }

  static Future<http.Response> postBinaryRequest(Uint8List body, String endpoint) {
    return http.post(
      Uri.parse(hostname + endpoint),
      headers: <String, String>{
        'Accept': '*/*',
        'Accept-Encoding': 'gzip, deflate, br',
        'Connection': 'keep-alive',
      },
      body: body
    );
  }
}