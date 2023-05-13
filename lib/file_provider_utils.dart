import 'dart:io';
import 'dart:typed_data';

class FileProviderUtils {
  static const String cacheDir = '/data/user/0/com.example.ambient_assistant/cache/';

  static Future<Uint8List> getBytes(String filename) {
    return File(cacheDir + filename).readAsBytes();
  }
}