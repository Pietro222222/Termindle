import 'dart:io';
import 'package:collection/collection.dart';
import 'package:dart_console2/dart_console2.dart';
import 'package:epubx/epubx.dart';
import 'package:terminal_reader/storage/books_info.dart';
import 'package:terminal_reader/terminal_reader.dart';
import 'package:terminal_reader/widgets/book_text.dart';
import 'package:terminal_reader/widgets/widget.dart';

class ChapterSelection extends Widget {
  final EpubBook book;
  late List<EpubChapter> chapters;
  late List<List<EpubChapter>> chapterPages;
  int chapterPage = 0, selectedChapter = 0;
  BookText? text;
  bool isTextSelected = false;

  ChapterSelection(this.book) {
    chapters = _getChapters(book.Chapters);
  }

  ChapterSelection.withInfo(this.book, BookInfo info) {
    chapters = _getChapters(book.Chapters);
    chapterPage =
        ((info.chapter - 1) / (stdout.terminalLines - 5)).floor();
    selectedChapter = (info.chapter - 1) % (stdout.terminalLines - 5);

    text = BookText.fromInfo(chapterPages[chapterPage][selectedChapter], info);
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

    chapterPages = chaptersFiltered.slices(stdout.terminalLines - 5).toList();
    return chaptersFiltered;
  }

  void draw() {
    var chapterCount = 0;
    for (var chapter in chapterPages[chapterPage]) {
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
        } else {
          if (chapterPage < (chapterPages.length - 1)) {
            chapterPage++;
            selectedChapter = 0;
          }
        }
      case 104:
      case 68:
        if (isTextSelected) {
          text!.previousPage();
        } else {
          if (chapterPage > 0) {
            chapterPage--;
            selectedChapter = 0;
          }
        }
      case 13:
        text = BookText(chapterPages[chapterPage][selectedChapter]);
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
