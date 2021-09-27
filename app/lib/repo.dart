import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Repository {
  final String author;
  final String title;
  final String description;
  final String languageName;
  final String stars;
  final String contributors;

  late bool bookmarked;
  late Map<String, Color> languageColors;

  Repository({
    required this.author,
    required this.title,
    required this.description,
    required this.languageName,
    required this.stars,
    required this.contributors,
  }) {
    languageColors = {
      "Python": Colors.green.shade300,
      "Go": Colors.blue,
      "TypeScript": Colors.blue.shade200,
      "JavaScript": Colors.amber,
      "C++": Colors.pink,
      "Elixir": Colors.purple,
      "Ruby": Colors.pink.shade900,
      "Shell": Colors.green.shade400,
      "Java": Colors.brown,
      "Rust": Colors.brown.shade400,
      "Markdown": Colors.grey.shade300,
      "Swift": Colors.amber.shade900,
      "PowerShell": Colors.blue.shade800,
      "Dart": Colors.blue,
      "": Colors.white
    };
    bookmarked = false;
  }

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      author: json['author'],
      title: json['title'],
      description: json['description'],
      languageName: json['language'],
      stars: json['stars'],
      contributors: json['contributors'],
    );
  }
}

Future<Repository> fetchRepositories(final List<int> alreadySent) async {
  var url = "http://localhost:3000/getRandomRepo";
  final Map data = {
    "alreadySent": alreadySent
  };
  var body = json.encode(data);


  final response = await http.post(Uri.parse(url), 
    headers: {"Content-Type": "application/json"},
    body: body
  );

  if(response.statusCode == 200) {
    return Repository.fromJson(jsonDecode(response.body));
  } else {
    throw Exception("Failed to load repo");
  }
}