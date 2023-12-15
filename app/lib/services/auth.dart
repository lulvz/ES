import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_wizard/services/database.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // auth user stream
  Stream<User?> get user {
    return _auth.authStateChanges();
  }

  // get user uid
  String getUid() {
    return _auth.currentUser!.uid;
  }

  // sign in anonymously, async task
  Future signInAnon() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;
      return user;
    } catch (e) {
      // print(e.toString()); // just print the error xd
      return null;
    }
  }

  //sign in with email and password
  Future signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // register with email and password
  Future registerWithEmailAndPassword(
      String email, String userName, String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;

      //create a new document for the user with the uid
      if (user != null) {
        await DatabaseService(uid: user.uid).updateUserData(email, userName);
        await DatabaseService(uid: user.uid).updateUserIngredients('celery', 0.0);
      }
      return user;
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }

  // sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      // print(e.toString());
      return null;
    }
  }
}
