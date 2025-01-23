import 'package:equatable/equatable.dart';

class Blog extends Equatable {
  final String id;
  final String title;
  final String content;
  final String photoUrl;
  final List<String> categories;

  const Blog({
    required this.id,
    required this.title,
    required this.content,
    required this.photoUrl,
    required this.categories,
  });

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
      id: json['_id'],
      title: json['title'],
      content: json['content'],
      photoUrl: json['photoUrl'],
      categories: List<String>.from(json['categories']),
    );
  }

  @override
  String toString() =>
      'Blog( id: $id, title: $title, content: $content, photoUrl: $photoUrl, categories: $categories)';

  @override
  List<Object> get props => [title, content, photoUrl];
}
