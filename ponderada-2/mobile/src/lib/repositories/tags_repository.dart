import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobile/models/tags.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TagsRepository {
  final url = 'http://10.0.2.2:8000';

  Future<List<Tag>> fetchTags() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userToken = prefs.getString('UserToken') ?? '';
    try {
      final response = await http.get(
        Uri.parse('$url/tag?user_toke=$userToken'), // Corrected endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      final body = json.decode(response.body);
      final list = body['founds'] as List;

      List<Tag> tags = [];

      for (var item in list) {
        tags.add(Tag.fromJson(item));
      }

      return tags;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<Tag> getTag(idTag) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    try {
      final response = await http.get(
        Uri.parse('$url/tag?tag_id=$idTag'), // Corrected endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final tagResponse = Tag.fromJson(json.decode(response.body));
        return tagResponse;
      }
      return Tag();
    } catch (e) {
      print(e);
      return Tag();
    }
  }

  Future<Tag> createTag(name, description) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    final userToken = prefs.getString('UserToken') ?? '';
    try {
      final response = await http.post(
        Uri.parse('$url/tag'), // Corrected endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: jsonEncode({
          'user_token': userToken,
          'name': name,
          'description': description,
        }),
      );
      if (response.statusCode == 200) {
        final tagResponse = Tag.fromJson(json.decode(response.body));
        return tagResponse;
      }
      return Tag();
    } catch (e) {
      print(e);
      return Tag();
    }
  }

  Future<Tag> deleteTag(idTag) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token') ?? '';
    try {
      final response = await http.get(
        Uri.parse('$url/tag?tag_id=$idTag'), // Corrected endpoint
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );
      if (response.statusCode == 200) {
        final tagResponse = Tag.fromJson(json.decode(response.body));
        return tagResponse;
      }
      return Tag();
    } catch (e) {
      print(e);
      return Tag();
    }
  }
}
