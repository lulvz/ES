// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../inventory/inventory_page.dart';
import '../search/search_page.dart';
import '../search/recipe.dart';

import 'package:recipe_wizard/services/auth.dart';
import 'package:recipe_wizard/services/database.dart';


class HomePage extends StatefulWidget {
  const HomePage({required Key key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red[400],
        centerTitle: true,
        title: Text(
          widget.title,
          style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins'),
        ),
        actions: <Widget>[
          IconButton(
            key: const Key('logout_button'),
            icon: const Icon(Icons.exit_to_app),
            onPressed: () {
              try {
                _auth.signOut();
              } catch (e) {
                print(e);
                return;
              }
            },
          ),
        ],
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
            return Center(
                child: ListView.builder(
                    itemCount: recipes.length,
                    itemBuilder: (context, index) {
                      final recipe = recipes[index];
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
                    }));
          }),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'inventory',
            key: const Key("inventory_button"),
            backgroundColor: Colors.red[400],
            child: const Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InventoryPage(
                    key: Key('inventoryPage'),
                    title: 'Inventory',
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),
          FloatingActionButton(
            heroTag: 'search',
            key: const Key('search_button_home_page'),
            backgroundColor: Colors.red[400],
            child: const Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchPage(
                    key: Key('searchPage'),
                    title: 'Search',
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
