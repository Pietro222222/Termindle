import 'dart:io';

import 'package:dart_console2/dart_console2.dart';
import 'package:epubx/epubx.dart';
import 'package:terminal_reader/terminal_reader.dart';
import 'package:terminal_reader/widgets/selector/book.dart';
import 'package:terminal_reader/widgets/selector/search_bar.dart';
import 'package:terminal_reader/widgets/widget.dart';
import 'package:collection/collection.dart';

class BookSelector extends Widget {
  late List<List<BookWidget>> books;
  List<EpubBook> booksRaw;
  EpubBook? selectedBook;
  int page, selected;

  SearchBar bar = SearchBar();

  BookSelector(this.booksRaw, {this.page = 0, this.selected = 0}) {
    getBooks();
  }

  void getBooks() {
    books = booksRaw
        .where((book) {
          var namePlusAuthor =
              "${book.Title!} ${book.Author != null ? "by ${book.Author!}" : ""}";
          return namePlusAuthor.contains(bar.query);
        })
        .map((bk) => BookWidget(bk))
        .slices((stdout.terminalLines - 5))
        .toList();
  }

  void listen(int key) {
    switch (key) {
      case 106:
      case 65:
        if (selected > 0) {
          selected--;
        }
      case 107:
      case 66:
        if (selected < (books[page].length - 1)) {
          selected++;
        }

      case 67:
        if (page < books.length - 1) {
          page++;
        }

      case 68:
        if (page > 0) {
          page--;
        }

      case 13:
        selectedBook = books[page][selected].book;
      default:
        bar.listen(key);
        getBooks();
    }
  }

  @override
  void build() {
    console.clearScreen();
    bar.build();
    console.cursorPosition = Coordinate(3, 0);
    if (books.isNotEmpty) {
      books[page].forEachIndexed((index, element) {
        if (index == selected) {
          console.setForegroundColor(ConsoleColor.white);
          console.setBackgroundColor(ConsoleColor.black);
        } else {
          console.setForegroundColor(ConsoleColor.black);
          console.setBackgroundColor(ConsoleColor.white);
        }
        element.build();
        console.resetColorAttributes();
      });
    }
  }
}
