// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:recipe_wizard/services/auth.dart';
import 'package:recipe_wizard/services/database.dart';

import 'package:recipe_wizard/services/search.dart';

import 'package:url_launcher/url_launcher.dart';

import 'package:recipe_wizard/ui/search/recipe.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  String searchValue = '';
  int missingIngredients = 0;
  bool isSearchBarVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 134, 168, 2),
        leading: IconButton(
          key: const Key('back_button_search_page'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins'),
        ),
      ),
      body: StreamBuilder<List<Recipe>>(
          stream: DatabaseService().recipeList,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              print(snapshot.error);
              return const Center(child: Text('Something went wrong'));
            }
            List<Recipe> recipes = snapshot.data!;
            return StreamBuilder<List<String>>(
              stream: DatabaseService(uid: AuthService().getUid())
                  .userIngredientsList,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: 
                    CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                    )
                  );
                }
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return const Center(child: Text('Something went wrong'));
                }
                List<String> ingredients = snapshot.data!;

                List<Recipe> filteredRecipes =
                    searchRecipes(recipes, ingredients, missingIngredients);

                if (searchValue != '') {
                  // standard search in list, this code is used in many documentation examples in flutter
                  // we decided on using it because of its simplicity, and since it doesn't affect the
                  // "unique" parts of the app, we decided to keep it
                  filteredRecipes = filteredRecipes
                      .where((element) => element.name
                          .toLowerCase()
                          .contains(searchValue.toLowerCase()))
                      .toList();
                }
                //search bar to search for recipes
                if (ingredients.isEmpty) {
                  return const Center(
                    child: Text(
                      "You don't have any ingredients!",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                else if (filteredRecipes.isEmpty) {
                  return const Center(
                    child: Text(
                      'No recipes found!',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  return Column(
                    children: [
                      if (isSearchBarVisible)
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: 
                          TextField(
                            key: const Key('search_bar'),
                            onChanged: (value) {
                              setState(() {
                                searchValue = value;
                              });
                            },
                            cursorColor: Colors.black, // Set the cursor color to black
                            decoration: const InputDecoration(
                              hintText: 'Search for recipes',
                              focusedBorder: UnderlineInputBorder (
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                            ),
                        )
                      ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: filteredRecipes.length,
                          itemBuilder: (context, index) {
                            final recipe = filteredRecipes[index];
                            return Card(
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              child: ListTile(
                                key: Key(recipe.name),
                                contentPadding: const EdgeInsets.all(16),
                                leading: Image.network(recipe.image),
                                title: Text(
                                  recipe.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                subtitle: Text(
                                  recipe.description,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.open_in_new),
                                  onPressed: () async {
                                    Uri link = Uri.parse(recipe.url);
                                    await launchUrl(link,
                                        mode: LaunchMode.externalApplication);
                                  },
                                ),
                                onTap: () async {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => RecipeDetailsPage(key: const Key('recipe_details_page'), recipe: recipe),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                }
              },
            );
          }
        ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'search',
            key: const Key("toggle_search_bar"),
            backgroundColor: const Color.fromARGB(255, 134, 168, 2),
            child: const Icon(Icons.search),
            onPressed: () {
              if (isSearchBarVisible) {
                setState(() {
                  searchValue = '';
                });
              }
              setState(() {
                isSearchBarVisible = !isSearchBarVisible;
              });
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'filter',
            key: const Key("filter_button_search_page"),
            backgroundColor: const Color.fromARGB(255, 134, 168, 2),
            child: const Icon(Icons.filter_alt),
            onPressed: () {
              // open a dialog to select how many missing ingredients to filter by
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        "Filter by missing ingredients",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Text(
                            "Select the number of missing ingredients to filter by",
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'Poppins',
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                key: const Key("filter_button_0"),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 134, 168, 2)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    missingIngredients = 0;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "0",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                key: const Key("filter_button_1"),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 134, 168, 2)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    missingIngredients = 1;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "1",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                key: const Key("filter_button_2"),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 134, 168, 2)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    missingIngredients = 2;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "2",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                              ElevatedButton(
                                key: const Key("filter_button_3"),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all<
                                          Color>(
                                      const Color.fromARGB(255, 134, 168, 2)),
                                ),
                                onPressed: () {
                                  setState(() {
                                    missingIngredients = 3;
                                  });
                                  Navigator.pop(context);
                                },
                                child: const Text(
                                  "3",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
          ),
        ],
      ),
    );
  }
}
