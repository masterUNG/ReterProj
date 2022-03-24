import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first
class QuotesModel {
  final int id;
  final String quote;
  final String author;
  final String wallpaper;
  final int author_id;
  final String category;
  QuotesModel({
    required this.id,
    required this.quote,
    required this.author,
    required this.wallpaper,
    required this.author_id,
    required this.category,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'quote': quote,
      'author': author,
      'wallpaper': wallpaper,
      'author_id': author_id,
      'category': category,
    };
  }

  factory QuotesModel.fromMap(Map<String, dynamic> map) {
    return QuotesModel(
      id: (map['id'] ?? 0) as int,
      quote: (map['quote'] ?? '') as String,
      author: (map['author'] ?? '') as String,
      wallpaper: (map['wallpaper'] ?? '') as String,
      author_id: (map['author_id'] ?? 0) as int,
      category: (map['category'] ?? '') as String,
    );
  }

  factory QuotesModel.fromJson(String source) => QuotesModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
