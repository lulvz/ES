import 'package:recipe_wizard/services/search.dart';
import 'package:recipe_wizard/services/database.dart';
import 'package:flutter_test/flutter_test.dart';


void main() {
  test('searchRecipes filters recipes by ingredients', () {
    // Create some sample recipes
    Recipe recipe1 = Recipe(
      id: '1',
      name: 'Pasta with tomato sauce',
      description: 'A classic Italian dish',
      ingredients: ['pasta', 'tomato sauce', 'garlic', 'olive oil'],
      url: 'https://www.example.com/pasta',
      image: 'https://www.example.com/pasta.jpg',
    );
    Recipe recipe2 = Recipe(
      id: '2',
      name: 'Fried rice with vegetables',
      description: 'An Asian-inspired dish',
      ingredients: ['rice', 'soy sauce', 'vegetables', 'eggs'],
      url: 'https://www.example.com/friedrice',
      image: 'https://www.example.com/friedrice.jpg',
    );
    Recipe recipe3 = Recipe(
      id: '3',
      name: 'Chicken stir-fry',
      description: 'A quick and easy dish',
      ingredients: ['chicken', 'vegetables', 'soy sauce', 'garlic'],
      url: 'https://www.example.com/stirfry',
      image: 'https://www.example.com/stirfry.jpg',
    );
    List<Recipe> recipes = [recipe1, recipe2, recipe3];

    // Test filtering with one ingredient
    List<String> inventory1 = ['rice', 'soy sauce', 'vegetables', 'eggs'];
    List<Recipe> expectedRecipes1 = [recipe2];
    expect(searchRecipes(recipes, inventory1, 0), expectedRecipes1);

    // Test filtering with two ingredients
    List<String> inventory2 = ['rice', 'soy sauce', 'vegetables', 'eggs', 'chicken', 'vegetables', 'soy sauce', 'garlic'];
    List<Recipe> expectedRecipes2 = [recipe2, recipe3];
    expect(searchRecipes(recipes, inventory2, 0), expectedRecipes2);

    // Test filtering with all ingredients
    List<String> inventory3 = ['pasta', 'tomato sauce', 'garlic', 'olive oil', 'rice', 'soy sauce', 'vegetables', 'eggs', 'chicken', 'vegetables', 'soy sauce', 'garlic'];
    List<Recipe> expectedRecipes3 = [recipe1, recipe2, recipe3];
    expect(searchRecipes(recipes, inventory3, 0), expectedRecipes3);

    // Test filtering with no ingredients
    List<String> inventory4 = [];
    List<Recipe> expectedRecipes4 = [];
    expect(searchRecipes(recipes, inventory4, 0), expectedRecipes4);
  });
}
