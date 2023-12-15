import 'dart:async';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:glob/glob.dart';
import 'package:gherkin/gherkin.dart';
import 'step/steps.dart';

Future<void> main() {
  final config = FlutterTestConfiguration()
    ..features = [Glob('test_driver/features/**.feature')]
    ..reporters = [
      ProgressReporter(),
      TestRunSummaryReporter(),
      JsonReporter(path: './report.json')
    ] // you can include the "StdoutReporter()" without the message level parameter for verbose log information
    ..stepDefinitions = [
      TapByKey(),
      KeyPresent(),
      WriteCredentials(),
      AndTapByKey()
    ]
    ..restartAppBetweenScenarios = true
    ..targetAppPath = "test_driver/app.dart"
    ..defaultTimeout= const Duration(seconds: 10);
  return GherkinRunner().execute(config);
}