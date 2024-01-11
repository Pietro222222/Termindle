import 'dart:io';

import 'package:dart_console2/dart_console2.dart';
import 'package:epubx/epubx.dart';
import 'package:terminal_reader/terminal_reader.dart';
import 'package:terminal_reader/widgets/widget.dart';

class BookTitle extends Widget {
  final EpubBook book;

  BookTitle(this.book);

  @override
  void build() {
    console.cursorPosition = Coordinate(0, 0);
    if (book.Title != null) {
      stdout.write("${book.Title}\n\r");
      console.writeLine('-' * (stdout.terminalColumns));
    }
  }
}
