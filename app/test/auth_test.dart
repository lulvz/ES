import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipe_wizard/services/auth.dart';

import 'package:mockito/annotations.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';

@GenerateMocks([
  MockSpec<User>,
  MockSpec<AuthService>,  // Use the correct class name
  MockSpec<MockFirebaseAuth>,  // Use the correct class name
  MockSpec<UserCredential>,  // Use the correct class name
])

class MockAuthService extends Mock implements AuthService {
  @override
  Future<UserCredential> registerWithEmailAndPassword(String email, String userName, String password) {
    return super.noSuchMethod(
      Invocation.method(#registerWithEmailAndPassword, [email, userName, password]),
      returnValue: Future.value(MockUserCredential()),
      returnValueForMissingStub: Future.value(MockUserCredential()),
    ) as Future<UserCredential>;
  }
  
  @override
  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return super.noSuchMethod(
      Invocation.method(#signInWithEmailAndPassword, [email, password]),
      returnValue: Future.value(MockUserCredential()),
      returnValueForMissingStub: Future.value(MockUserCredential()),
    ) as Future<UserCredential>;
  }

  @override
  Future<void> signOut() {
    return super.noSuchMethod(
      Invocation.method(#signOut, []),
      returnValue: Future.value(),
      returnValueForMissingStub: Future.value(),
    ) as Future<void>;
  }
}
class MockUserCredential extends Mock implements UserCredential {
  @override
  User? get user => super.noSuchMethod(
    Invocation.getter(#user),
    returnValue: MockUser(),
    returnValueForMissingStub: MockUser(),
  ) as User?;
}

void main() {
  group('Authentication Service Tests', () {
    late MockAuthService mockAuthService;
    // late MockFirebaseAuth mockFirebaseAuth;
    late MockUserCredential mockUserCredential;

    setUp(() {
      mockAuthService = MockAuthService();
      // mockFirebaseAuth = MockFirebaseAuth();
      mockUserCredential = MockUserCredential();
    });

    test('register with email and password', () async {
      when(mockAuthService.registerWithEmailAndPassword('test@example.com', 'test', 'password'))
          .thenAnswer((_) => Future.value(mockUserCredential));

      final result = await mockAuthService.registerWithEmailAndPassword('test@example.com', 'test', 'password');

      expect(result, equals(mockUserCredential));
      verify(mockAuthService.registerWithEmailAndPassword('test@example.com', 'test', 'password'));
    });

    test('sign in with email and password', () async {
      when(mockAuthService.signInWithEmailAndPassword('test@example.com', 'password'))
          .thenAnswer((_) => Future.value(mockUserCredential));

      final result = await mockAuthService.signInWithEmailAndPassword('test@example.com', 'password');

      expect(result, equals(mockUserCredential));
      verify(mockAuthService.signInWithEmailAndPassword('test@example.com', 'password'));
    });

    test('sign out', () async {
      when(mockAuthService.signOut()).thenAnswer((_) => Future.value());

      await mockAuthService.signOut();

      verify(mockAuthService.signOut());
    });
  });
}
