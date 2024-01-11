import 'dart:io';

import 'package:dart_console2/dart_console2.dart';
import 'package:epubx/epubx.dart';
import 'package:terminal_reader/storage/books_info.dart';
import 'package:terminal_reader/terminal_reader.dart';
import 'package:terminal_reader/widgets/book_text.dart';
import 'package:terminal_reader/widgets/widget.dart';

class ChapterSelection extends Widget {
  final EpubBook book;
  late int selectedChapter;
  late List<EpubChapter> chapters;
  BookText? text;
  bool isTextSelected = false;

  ChapterSelection(this.book) {
    selectedChapter = 0;
    chapters = _getChapters(book.Chapters);
  }

  ChapterSelection.withInfo(this.book, BookInfo info) {
    selectedChapter = info.chapter;
    chapters = _getChapters(book.Chapters);
    text = BookText.fromInfo(chapters[selectedChapter], info);
    isTextSelected = true;
  }

  List<EpubChapter> _getChapters(List<EpubChapter>? chapters) {
    if (chapters == null) {
      return [];
    }

    List<EpubChapter> chaptersFiltered = [];
    var lists = chapters.map((chapter) {
      List<EpubChapter> chapters = [];
      if (BookText(chapter).chapterText.isNotEmpty) {
        chapters.add(chapter);
      }
      chapters.addAll(_getChapters(chapter.SubChapters));
      return chapters;
    });
    for (var list in lists) {
      chaptersFiltered.addAll(list);
    }
    return chaptersFiltered;
  }

  void draw() {
    var chapterCount = 0;
    for (var chapter in chapters) {
      if (selectedChapter == chapterCount) {
        console.setForegroundColor(ConsoleColor.white);
        console.setBackgroundColor(ConsoleColor.black);
      } else {
        console.setForegroundColor(ConsoleColor.black);
        console.setBackgroundColor(ConsoleColor.white);
      }
      stdout.write("${chapter.Title!}\n\r");
      chapterCount = chapterCount + 1;
    }
  }

  void listen(int key) {
    switch (key) {
      case 106:
      case 65:
        if (selectedChapter > 0) {
          selectedChapter--;
        }
      case 107:
      case 66:
        if (selectedChapter < (chapters.length - 1)) {
          selectedChapter++;
        }
      case 108:
      case 67:
        if (isTextSelected) {
          text!.nextPage();
        }
      case 104:
      case 68:
        if (isTextSelected) {
          text!.previousPage();
        }
      case 13:
        text = BookText(chapters[selectedChapter]);
        if (text!.chapterText.isNotEmpty) {
          isTextSelected = true;
        }
      case 11:
        if (text != null) {
          isTextSelected = !isTextSelected;
          console.cursorPosition = Coordinate(3, 0);
          console
              .write(" " * (stdout.terminalLines - 3) * stdout.terminalColumns);
        }
    }

    build();
  }

  @override
  void build() {
    console.cursorPosition = Coordinate(3, 0);
    if (isTextSelected) {
      text!.build();
    } else if (book.Chapters != null) {
      draw();
    }
    console.resetColorAttributes();
  }
}
