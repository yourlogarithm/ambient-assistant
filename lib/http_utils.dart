import 'dart:convert';
import 'package:http/http.dart' as http;

class HttpUtils {
  static String hostname = "http://192.168.109.123:80/";

  static Future<http.Response> postRequest(Map<String, String> body, String endpoint) {
    return http.post(
      Uri.parse(hostname + endpoint),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(body),
    );
  }

  static dynamic postFile(String endpoint, String filename) async {
    var request = http.MultipartRequest('POST', Uri.parse(hostname + endpoint));
    request.files.add(await http.MultipartFile.fromPath('file', filename));
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      return await response.stream.bytesToString();
    } else {
      print(response.reasonPhrase);
    }
  }
}