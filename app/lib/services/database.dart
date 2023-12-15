import 'package:cloud_firestore/cloud_firestore.dart';

class Recipe {
  final String id;
  final String name;
  final String description;
  final List<String> ingredients;
  final String url;
  final String image;

  Recipe(
      {required this.id,
      required this.name,
      required this.description,
      required this.ingredients,
      required this.url,
      required this.image});
}

class DatabaseService {
  final String uid;
  final FirebaseFirestore firestore;

  // default firestore is used if no firestore is passed in
  // this is useful for unit testing
  DatabaseService({this.uid = '', FirebaseFirestore? firestore})
      : firestore = firestore ?? FirebaseFirestore.instance;

  Future updateUserData(String email, String userName) async {
    await firestore.collection('users').doc(uid).set({
      'email': email,
      'username': userName,
    });
  }

  Future updateUserIngredients(String ingredientId, double quantity) async {
    return await firestore.collection('users')
        .doc(uid)
        .collection('ingredients')
        .doc(ingredientId)
        .set({
      'ingredient_id': ingredientId,
      'quantity': quantity,
    });
  }

  // remove user ingredient
  Future removeUserIngredient(String ingredientId) async {
    return await firestore.collection('users')
        .doc(uid)
        .collection('ingredients')
        .doc(ingredientId)
        .delete();
  }

  // get user name
  Future<String> getUserName() async {
    DocumentSnapshot userSnapshot = await firestore.collection('users').doc(uid).get();
    // print if its from cache or not
    // print(userSnapshot.metadata.isFromCache);
    return userSnapshot.get('username');
  }

  Stream<QuerySnapshot> get recipes {
    return firestore.collection('recipes').snapshots();
  }

  Stream<List<Recipe>> get recipeList {
    return firestore.collection('recipes').snapshots().map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return Recipe(
          id: doc.id,
          name: doc.get('name'),
          description: doc.get('description'),
          ingredients: (doc.get('ingredients') as List<dynamic>).cast<String>(),
          url: doc.get('url'),
          image: doc.get('image')
        );
      }).toList();
    });
  }

  // Stream<QuerySnapshot> get ingredients {
  //   return ingredientCollection.snapshots();
  // }

  Stream<QuerySnapshot> get userIngredients {
    return firestore.collection('users')
        .doc(uid)
        .collection('ingredients')
        .snapshots();
  }

  Stream<List<String>> get userIngredientsList {
    return firestore.collection('users')
        .doc(uid)
        .collection('ingredients')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return doc.get('ingredient_id') as String;
      }).toList();
    });
  }
}
