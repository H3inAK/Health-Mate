import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../utils/custom_error.dart';
import '../constants/constants.dart';
import '../models/blog_model.dart';

class BlogsRepository {
  final http.Client httpClient;
  BlogsRepository({
    required this.httpClient,
  });

  int _totalPages = 1;

  int get totalPages => _totalPages;

  Future<List<Blog>> fetchBlogs({int page = 1, int limit = 5}) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$apiHost/blogs?page=$page&limit=$limit'),
      );

      if (response.statusCode == 400) {
        return <Blog>[];
      }

      if (response.statusCode == 500) {
        throw const CustomError(
          code: 'Server Exception',
          message: 'Internal Server Error',
          plugin: 'flutter_error/server_error',
        );
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> blogsJson = jsonResponse['data']['blogs'];
        _totalPages = jsonResponse['totalPages'];

        final blogs =
            blogsJson.map((blogJson) => Blog.fromJson(blogJson)).toList();

        return blogs;
      }

      return <Blog>[];
    } on http.ClientException catch (e) {
      throw CustomError(
        code: 'ClientException',
        message: e.message,
        plugin: 'flutter_error/http_client_error',
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<List<String>> fetchCategories() async {
    try {
      final response = await httpClient.get(
        Uri.parse('$apiHost/blogs/categories'),
      );

      if (response.statusCode == 400) {
        return <String>['All'];
      }

      if (response.statusCode == 500) {
        throw const CustomError(
          code: 'Server Exception',
          message: 'Internal Server Error',
          plugin: 'flutter_error/server_error',
        );
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> categoriesJson = jsonResponse['data']['categories'];
        final categories = categoriesJson.cast<String>();

        return categories;
      }

      return <String>['All'];
    } on http.ClientException catch (e) {
      throw CustomError(
        code: 'ClientException',
        message: e.message,
        plugin: 'flutter_error/http_client_error',
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<List<Blog>?> fetchBlogsByCategory(String category,
      {int page = 1, int limit = 5}) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$apiHost/blogs?category=$category&page=$page&limit=$limit'),
      );

      if (response.statusCode == 400) {
        return <Blog>[];
      }

      if (response.statusCode == 500) {
        throw const CustomError(
          code: 'Server Exception',
          message: 'Internal Server Error',
          plugin: 'flutter_error/server_error',
        );
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> blogsJson = jsonResponse['data']['blogs'];

        final blogs =
            blogsJson.map((blogJson) => Blog.fromJson(blogJson)).toList();

        return blogs;
      }

      return null;
    } on http.ClientException catch (e) {
      throw CustomError(
        code: 'ClientException',
        message: e.message,
        plugin: 'flutter_error/http_client_error',
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<List<Blog>?> fetchBlogsBySearch(String query,
      {int page = 1, int limit = 5}) async {
    try {
      final response = await httpClient.get(
        Uri.parse('$apiHost/blogs?searchTerm=$query&page=$page&limit=$limit'),
      );

      if (response.statusCode == 400) {
        return <Blog>[];
      }

      if (response.statusCode == 500) {
        throw const CustomError(
          code: 'Server Exception',
          message: 'Internal Server Error',
          plugin: 'flutter_error/server_error',
        );
      }

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = json.decode(response.body);
        final List<dynamic> blogsJson = jsonResponse['data']['blogs'];
        final blogs =
            blogsJson.map((blogJson) => Blog.fromJson(blogJson)).toList();

        return blogs;
      }

      return null;
    } on http.ClientException catch (e) {
      throw CustomError(
        code: 'ClientException',
        message: e.message,
        plugin: 'flutter_error/http_client_error',
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
