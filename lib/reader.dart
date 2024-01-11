import 'dart:io';

import 'package:dart_console2/dart_console2.dart';
import 'package:epubx/epubx.dart';
import 'package:terminal_reader/storage/books_info.dart';
import 'package:terminal_reader/terminal_reader.dart';
import 'package:terminal_reader/widgets/chapter_selection.dart';
import 'package:terminal_reader/widgets/title.dart';
import 'package:terminal_reader/widgets/widget.dart';

class Reader extends Widget {
  late ChapterSelection chapterSelection;
  late BookTitle title;
  Books booksInfo;
  EpubBook book;

  Reader(this.book, this.booksInfo) {
    if (booksInfo.books.containsKey(book.Title!)) {
      var bookInfo = booksInfo.books[book.Title!]!;
      chapterSelection = ChapterSelection.withInfo(book, bookInfo);
    } else {
      chapterSelection = ChapterSelection(book);
    }
    title = BookTitle(book);
  }
  @override
  void build() {
    console.clearScreen();
    chapterSelection.build();
    title.build();
  }

  void listen(int key) {
    if (key == 127) {
      saveInfo();
    }
    console.cursorPosition = Coordinate(stdout.terminalLines, 0);
    stdout.write(key);
    chapterSelection.listen(key);
  }

  void saveInfo() {
    booksInfo.saveBook(chapterSelection);
    booksInfo.save();
  }
}
