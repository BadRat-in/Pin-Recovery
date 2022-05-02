import 'dart:io';
import 'package:path_provider/path_provider.dart';

class Savefile {
  static Future<String> get getfilepath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  static Future<File> get getNamefile async {
    final path = await getfilepath;
    return File('$path/Name.txt');
  }

  static Future<File> saveNamefile(String data) async {
    final file = await getNamefile;
    return file.writeAsString(data);
  }

  static readNamefile() async {
    try {
      final file = await getNamefile;
      String content = file.readAsStringSync();
      return content;
    } catch (e) {
      return '0';
    }
  }
}
