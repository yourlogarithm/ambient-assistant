import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class HttpUtils {
  static String hostname = "http://192.168.159.123:80/";

  static Future<http.Response> postRequest(Map<String, String> body, String endpoint) {
    return http.post(
      Uri.parse(hostname + endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }

  static Future<dynamic> postFile(String endpoint, String filename) async {
    var request = http.MultipartRequest('POST', Uri.parse(hostname + endpoint));
    request.files.add(await http.MultipartFile.fromPath('file', filename));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      print(response.reasonPhrase);
    }
  }

  static Future<dynamic> getRequest(String endpoint) async {
    var response = await http.get(Uri.parse(hostname + endpoint));
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print(response.reasonPhrase);
    }
  }

  static Future<dynamic> generateResponse(String transcript) async {
    final response = await http.get(Uri.parse('${hostname}chat/generate_response/?message=$transcript'));
    return response.bodyBytes;
  }

  static void deleteChat() async {
    final response = await http.delete(Uri.parse('${hostname}chat/reset'));
    debugPrint(response.statusCode.toString());
  }
}