import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';

class Ingredient {
  final String id;
  final String name;
  final String description;

  Ingredient({required this.id, required this.name, required this.description});

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      description: json['description'],
    );
  }
}

// todo: class Recipe

// todo: make this class read also from assets/db/recipes.json
class LocalDatabaseService {
  // json file in assets folder
  static const String _jsonFile = 'assets/db/ingredients.json';
  List<Ingredient> ingredients = [];

  Future<String> _loadJson() async {
    return await rootBundle.loadString(_jsonFile);
  }

  Future<List<Ingredient>> loadIngredients() async {
    String jsonString = await _loadJson();
    final jsonResponse = json.decode(jsonString);
    List<Ingredient> newIngredients = [];
    jsonResponse.forEach((key, value) {
      newIngredients.add(Ingredient.fromJson({
        'id': key,
        'name': value['name'],
        'description': value['description'],
      }));
    });
    ingredients = newIngredients;
    return ingredients;
  }

  Future<Ingredient?> getIngredientById(String ingredientId) async {
    if (ingredients.isEmpty) {
      loadIngredients();
    }
    return ingredients.firstWhere((ingredient) => ingredient.id == ingredientId);
  }
}
