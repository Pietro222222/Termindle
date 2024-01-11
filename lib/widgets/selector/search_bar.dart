import 'dart:io';

import 'package:dart_console2/dart_console2.dart';
import 'package:terminal_reader/terminal_reader.dart';
import 'package:terminal_reader/widgets/widget.dart';

class SearchBar extends Widget {
  String query;

  SearchBar({this.query = ""});

  void listen(int key) {
    if (key == 127 && query.isNotEmpty) {
      query = query.substring(0, query.length - 1);
    } else {
      query = query + String.fromCharCode(key);
    }
  }

  @override
  void build() {
    console.cursorPosition = Coordinate(0, 0);
    stdout.write('\r$query\n\r');
    stdout.write('-' * stdout.terminalColumns);
  }
}
