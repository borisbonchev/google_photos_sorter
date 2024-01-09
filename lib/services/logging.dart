import 'package:logging/logging.dart';

final Logger logger = Logger('MyApp');

// ignore_for_file: avoid_print
void setupLogger() {
  Logger.root.level = Level.ALL;

  Logger.root.onRecord.listen((LogRecord rec) {
    print('${rec.level.name}: ${rec.time}: \n${rec.message}'); // Output log messages to the console
    if (rec.error != null) {
      print('Error: ${rec.error}');
    }
    if (rec.stackTrace != null) {
      print('Stack trace: ${rec.stackTrace}');
    }
  });
}