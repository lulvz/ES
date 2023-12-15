import 'package:recipe_wizard/services/database.dart';

List<Recipe> searchRecipes(List<Recipe> recipes, List<String> ingredients, int targetMissinIngredients) {
  List<Recipe> filteredRecipes = [];
  for (var recipe in recipes) {
    int missingIngredients = 0;
    for (var ingredient in recipe.ingredients) {
      if (!ingredients.contains(ingredient)) {
        missingIngredients++;
      }
    }
    if (missingIngredients <= targetMissinIngredients) {
      filteredRecipes.add(recipe);
    }
  }
  return filteredRecipes;
}

