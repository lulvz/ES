import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';
import 'package:recipe_wizard/services/database.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

import 'package:flutter_test/flutter_test.dart';


class MockFirebaseFirestore extends Mock implements FirebaseFirestore {}

void main() {
  // Initialize fake Cloud Firestore instance
  FakeFirebaseFirestore fakeFirestore = FakeFirebaseFirestore();
  // DatabaseService databaseService;

  setUpAll(() {
    // Use fake Firestore instance for testing
    fakeFirestore = FakeFirebaseFirestore();
    // databaseService = DatabaseService(firestore: fakeFirestore);
  });

  group('Database', () {
    test('updateUserData', () async {
      // Set up test data
      const email = 'test@example.com';
      const userName = 'Test User';

      // Create instance of DatabaseService with fake Firestore instance
      final databaseService = DatabaseService(uid: 'test_uid', firestore: fakeFirestore);

      // Call the updateUserData method with test data
      await databaseService.updateUserData(email, userName);

      // Verify that the user data was updated in the fake Firestore instance
      final userDoc = fakeFirestore.collection('users').doc('test_uid');
      final userSnapshot = await userDoc.get();
      expect(userSnapshot.exists, true);
      expect(userSnapshot.get('email'), email);
      expect(userSnapshot.get('username'), userName);
    });

    test('updateUserIngredients', () async {

      const String ingredientId = 'test_ingredient_id';
      const double quantity = 1.0;

      final databaseService = DatabaseService(uid: 'test_uid', firestore: fakeFirestore);
      
      await databaseService.updateUserIngredients(ingredientId, quantity);

      final userDoc = fakeFirestore.collection('users').doc('test_uid').collection('ingredients').doc(ingredientId);
      final userSnapshot = await userDoc.get();
      expect(userSnapshot.exists, true);
      expect(userSnapshot.get('ingredient_id'), ingredientId);
      expect(userSnapshot.get('quantity'), quantity);
    });
  });
}
