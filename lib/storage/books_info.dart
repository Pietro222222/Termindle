import 'dart:convert';
import 'dart:io';

import 'package:terminal_reader/widgets/chapter_selection.dart';

class BookInfo {
  int position;
  int terminalRow;
  int terminalColumn;
  int chapter;

  String title;

  BookInfo(
      {required this.position,
      required this.terminalRow,
      required this.terminalColumn,
      required this.chapter,
      required this.title});

  factory BookInfo.fromJson(Map<String, dynamic> json) => BookInfo(
        position: json["position"],
        terminalRow: json["terminalRow"],
        terminalColumn: json["terminalColumn"],
        chapter: json["chapter"],
        title: json["title"],
      );

  Map toJson() => {
        'position': position,
        'terminalRow': terminalRow,
        'terminalColumn': terminalColumn,
        'chapter': chapter,
        'title': title
      };
}

class Books {
  late Map<String, BookInfo> books;
  late String storage;

  Books(this.books, this.storage);

  Books.fromJson(Map<String, dynamic> json)
      : books = json as Map<String, BookInfo>;

  Books.retrieveStorage(this.storage) {
    Map<String, dynamic> info = jsonDecode(File(storage).readAsStringSync());
    books = info.map((key, value) {
      return MapEntry(key, BookInfo.fromJson(value));
    });
  }
  void save() {
    var file = File(storage);
    file.writeAsStringSync(jsonEncode(books));
  }

  void saveBook(ChapterSelection widget) {
    if (widget.text == null) {
      return;
    }
    var chapter = widget.chapterPage * (stdout.terminalLines - 5) + (widget.selectedChapter + 1);
    var info = BookInfo(
        position: widget.text!.position,
        terminalRow: stdout.terminalLines,
        terminalColumn: stdout.terminalColumns,
        chapter: chapter,
        title: widget.book.Title!);
    if (books.containsKey(widget.book.Title!)) {
      books.update(widget.book.Title!, (value) => info);
      return;
    }
    books.putIfAbsent(widget.book.Title!, () => info);
  }
}
