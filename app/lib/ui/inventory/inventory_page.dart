import 'package:flutter/material.dart';

import 'package:recipe_wizard/services/auth.dart';
import 'package:recipe_wizard/services/database.dart';
import 'package:recipe_wizard/services/local_database.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({required Key key, required this.title})
      : super(key: key);

  final String title;

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  var ldb = LocalDatabaseService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple[400],
        leading: IconButton(
          key: const Key('back_button_inventory_page'),
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(widget.title,
          style: const TextStyle(
          color: Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
          fontFamily: 'Poppins'),
        ),
      ),
      body: StreamBuilder(
        stream: DatabaseService(uid: AuthService().getUid()).userIngredientsList,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          }
          if(!snapshot.hasData) {
            return const Text("No data");
          }

          return FutureBuilder(
            future: ldb.loadIngredients(),
            builder: (BuildContext context, AsyncSnapshot<List<Ingredient>> ingredientsSnapshot) {
              if (ingredientsSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
                  )
                );
              }
              if (ingredientsSnapshot.hasError) {
                return const Text("Error loading ingredients");
              }
              final ingredients = ingredientsSnapshot.data ?? [];
              final List<String> userIngredientIds = snapshot.data;
              List<Ingredient> filteredIngredients = [];
              // check if the ingredient is in the user's inventory
              for (var ingredient in ingredients) {
                if (userIngredientIds.contains(ingredient.id)) {
                  filteredIngredients.add(ingredient);
                }
              }
              // sort alphabetically by name
              filteredIngredients.sort((ingredient1, ingredient2) => ingredient1.name.compareTo(ingredient2.name));
              return Center(
                child: ListView.builder(
                  itemCount: filteredIngredients.length,
                  itemBuilder: (context, index) {
                    final ingredient = filteredIngredients[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        key: Key(ingredient.name),
                        title: Text(
                          ingredient.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        subtitle: Text(
                          ingredient.description,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            DatabaseService(uid: AuthService().getUid()).removeUserIngredient(ingredient.id);
                          },
                        ),
                        onTap: () {
                          
                        },
                      ),
                    );
                  },
                ),
              );
            },
          );          
        },
      ),
      // add button to add an ingredient from the possible ingredients in the local database
      floatingActionButton: FloatingActionButton(
        key: const Key("add_ingredient_button"),
        backgroundColor: Colors.pink[500],
        onPressed: () {
          // Create a ValueNotifier to track the text input value
          final searchText = ValueNotifier('');
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ValueListenableBuilder<String>(
                        valueListenable: searchText,
                        builder: (context, value, _) {
                          return TextField(
                            key: const Key("input_ingredient_id"),
                            cursorColor: Colors.black, // Set the cursor color to black
                            decoration: const InputDecoration(
                              hintText: "Search an ingredient",
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black87),
                              ),
                            ),
                            onChanged: (String value) {
                              searchText.value = value;
                            },
                          );
                        },
                      ),
                    ),
                    Flexible(
                      child: FutureBuilder<List<Ingredient>>(
                        future: ldb.loadIngredients(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: CircularProgressIndicator(),
                            );
                          }
                          if (snapshot.hasError) {
                            return const Text("Error loading ingredients");
                          }
                          final List<Ingredient> ingredients = snapshot.data ?? [];
                          // sort alphabetically by name
                          ingredients.sort((ingredient1, ingredient2) => ingredient1.name.compareTo(ingredient2.name));
                          return ValueListenableBuilder<String>(
                            valueListenable: searchText,
                            builder: (context, value, _) {
                              final filteredList = ingredients
                                  .where((ingredient) => ingredient.name
                                      .toLowerCase()
                                      .contains(value.toLowerCase()))
                                  .toList();
                              return ListView(
                                shrinkWrap: true,
                                children: [
                                  for (var ingredient in filteredList)
                                    ListTile(
                                      key: Key(ingredient.name),
                                      title: Text(
                                        ingredient.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      subtitle: Text(
                                        ingredient.description,
                                        style: const TextStyle(
                                          fontSize: 14,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                      onTap: () {
                                        DatabaseService(
                                                uid: AuthService().getUid())
                                            .updateUserIngredients(
                                                ingredient.id, 1.0);
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        tooltip: 'Add Ingredient',
        child: const Icon(Icons.add),
      ),
    );
  }
}
