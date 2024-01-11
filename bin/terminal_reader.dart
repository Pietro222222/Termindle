import 'package:terminal_reader/application.dart';
import 'package:terminal_reader/selector.dart';
import 'package:terminal_reader/terminal_reader.dart';

Future<void> main(List<String> arguments) async {
  console.rawMode = true;
  console.clearScreen();

  var app = App(Selector());
  await app.init();
  app.draw();
  app.listen();

  console.rawMode = false;
}
