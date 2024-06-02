import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:mobile/models/photo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PhotoService {
  final baseUrl = 'http://192.168.224.1:7000/photo';

  Future<List<Photo>> fetchTags() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userToken = prefs.getString('UserToken') ?? '';
    try {
      final response = await http.get(
        Uri.parse('$baseUrl?user_toke=$userToken'), // Corrected endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      final body = json.decode(response.body);
      final list = body['founds'] as List;

      List<Photo> photos = [];

      for (var item in list) {
        photos.add(Photo.fromJson(item));
      }

      return photos;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> uploadImage(File file, String url, String fileName) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userToken = prefs.getString('UserToken') ?? '';

    try {
      final request = http.MultipartRequest(
        'POST',
        Uri.parse(
            '$baseUrl?user_token=$userToken&file_name=$fileName&url=$url'),
      );
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      final response = await request.send();

      if (response.statusCode == 200) {
        final file = File(url);
        final bytes = await response.stream.toBytes();
        await file.writeAsBytes(bytes);

        print('Imagem salva em: $url');
        return url;
      } else {
        return "";
      }
    } catch (e) {
      print(e);
      return "";
    }
  }
}
