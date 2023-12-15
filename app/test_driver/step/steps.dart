import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';

// StepDefinitionGeneric GivenIAmOnLoginPage() {
//   return given1<String, FlutterWorld>(
//     'I am on the "login_form" page',
//     (pageName, context) async {
//       final loginForm = find.byValueKey('login_form');
//       await FlutterDriverUtils.isPresent(context.world.driver, loginForm);
//     },
//   );
// }

// // Create stepdefinitions for login feature
// StepDefinitionGeneric GivenIHaveLoggedIn() {
//   return given2<String, String, FlutterWorld>(
//     'I have logged in with the email {string} and password {string}',
//     (email, password, context) async {
//     final loginButton = find.byValueKey('login_button');
//     final emailField = find.byValueKey('email_field');
//     final passwordField = find.byValueKey('password_field');
//     final loginForm = find.byValueKey('login_form');

//     await FlutterDriverUtils.tap(context.world.driver, loginButton);
//     await FlutterDriverUtils.enterText(context.world.driver, emailField, email);
//     await FlutterDriverUtils.enterText(context.world.driver, passwordField, password);
//     await FlutterDriverUtils.tap(context.world.driver, loginForm);
//     },
//   );
// }

// StepDefinitionGeneric ThenIShouldSeeHomePage() {
//   return then1<String, FlutterWorld>(
//     'I should see the {string} page',
//     (pageName, context) async {
//       final homePage = find.byValueKey('home_page');
//       await FlutterDriverUtils.isPresent(context.world.driver, homePage);
//     },
//   );
// }

class TapByKey extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    final button = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, button);
  }

  @override
  RegExp get pattern => RegExp(r"When I tap the element with key {string}");
}

class KeyPresent extends Then1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    final loginfinder = find.byValueKey(key);
    bool isPresent =
        await FlutterDriverUtils.isPresent(world.driver, loginfinder);
    expect(isPresent, true);
  }

  @override
  RegExp get pattern =>
      RegExp(r"Then the element with key {string} is present");
}

class WriteCredentials extends When2WithWorld<String, String, FlutterWorld> {
  @override
  Future<void> executeStep(String field, String key) async {
    final button = find.byValueKey(key);
    await FlutterDriverUtils.enterText(world.driver, button, field);
  }

  @override
  RegExp get pattern => RegExp(r"When I write {string} in {string}");
}

class AndTapByKey extends When1WithWorld<String, FlutterWorld> {
  @override
  Future<void> executeStep(String key) async {
    final button = find.byValueKey(key);
    await FlutterDriverUtils.tap(world.driver, button);
  }

  @override
  RegExp get pattern => RegExp(r"And I tap the element with key {string}");
}

StepDefinitionGeneric TapListViewItemStep() {
  return given1<String, FlutterWorld>(
      'I tap the {string} item',
          (key, context) async {
        final locator = find.byValueKey(key);
        await FlutterDriverUtils.tap(context.world.driver, locator);
      }
  );
}

