import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:tech_wire/core/constants/ApiConstants.dart';
import 'package:tech_wire/data/models/Article.dart';

class ApiService {
  Future<List<Article>> fetchTopHeadlines({String category = "technology" }) async {
    final response = await http.get(Uri.parse('${ApiConstants
        .baseUrl}/top-headlines?country=us&category=$category&apiKey=${ApiConstants
        .apiKey}')
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final List articles = data['articles'];
      return articles.map((json) => Article.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load news");
    }
  }
}