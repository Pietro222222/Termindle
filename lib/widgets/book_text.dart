import 'dart:io';

import 'package:dart_console2/dart_console2.dart';
import 'package:epubx/epubx.dart';
import 'package:html/parser.dart';
import 'package:terminal_reader/storage/books_info.dart';
import 'package:terminal_reader/terminal_reader.dart';
import 'package:terminal_reader/widgets/widget.dart';

class BookText extends Widget {
  /*
  
  Math theory behind it

  Say you have a Terminal Area of A and another terminal area of B
  where A = γB and a text length of L.

  P(l, α) = l/α
  meaning, the number of pages (P of) depends on l (length) and α (area)

  P = L/A
  in terms of b: P' = L/γB. P = P'
  So lets say that we changed our terminal size from A to B, how do we calculate the number of pages.

  A/γ = B so L/B = L/A/γ meaning y * L/A (conversion).

  Okay, now the most interest thing.

  Lets say we have an objectively Area H and a dynamically determined area A
  using the equations previously described, transforming from H to A would required us to find γ
  lets go back to our previous example to understand how

  so γB = A, so if we divide both sides by B we get that γ = A/B. this is the gamma factor.

  therefore, the gamma factor between H and A is H/A

  H/A * L/A = HL/A^2

  this is the conversion equation: H*L/A^2

  bro im not understanding this math lol (i've written it);
  */
  late int position;
  late EpubChapter chapter;
  late String chapterText;

  late List<List<String>> pages;
  late int terminalArea = (stdout.terminalColumns) * (stdout.terminalLines - 3);

  BookText(this.chapter, {this.position = 0}) {
    var doc = parse(chapter.HtmlContent!);
    chapterText = parse(doc.body!.text).documentElement!.text;

    pages = divideChapter(chapterText);
  }

  BookText.fromInfo(EpubChapter chapterInfo, BookInfo info) {
    chapter = chapterInfo;

    var doc = parse(chapter.HtmlContent!);
    chapterText = parse(doc.body!.text).documentElement!.text;

    pages = divideChapter(chapterText);

    position = info.position;

    calculateNewPageFromInfo(position, info.terminalRow, info.terminalColumn);
  }
  void calculateNewPageFromInfo(
      int position, int terminalRows, int terminalColumns) {
    List<List<String>> infoPages =
        chapterText.divideString(terminalRows, terminalColumns);

    position = (position * infoPages.length / pages.length).round();
  }

  List<List<String>> divideChapter(String originalString) {
    return originalString.divideString(
        stdout.terminalLines, stdout.terminalColumns);
  }

  void nextPage() {
    if (position < pages.length - 1) {
      position++;
    }
  }

  void previousPage() {
    if (position > 0) {
      position--;
    }
  }

  @override
  void build() {
    console.cursorPosition = Coordinate(3, 0);
    console.write(" " * terminalArea);
    console.cursorPosition = Coordinate(3, 0);
    for (var line in pages[position]) {
      stdout.write("\r$line\n\r");
    }
  }
}

extension ChapterDivider on String {
  List<List<String>> divideString(int terminalRows, int terminalColumns) {
    List<String> _splitText(String text, int chunkSize) {
      List<String> result = [];

      for (int i = 0; i < text.length; i += chunkSize) {
        int end = (i + chunkSize < text.length) ? i + chunkSize : text.length;
        result.add(text.substring(i, end));
      }

      return result;
    }

    var _chapterLines = split('\n').map((str) {
      return _splitText(str, terminalColumns);
    }).toList();

    List<String> chapterLines = [];
    for (var lines in _chapterLines) {
      chapterLines.addAll(lines);
    }

    chapterLines = chapterLines.map((str) {
      return str.trim();
    }).toList();

    List<List<String>> result = [];
    var linesPerPage = terminalRows - 4;

    List<List<String>> breakArray(List<String> originalArray, int chunkSize) {
      List<List<String>> result = [];

      for (int i = 0; i < originalArray.length; i += chunkSize) {
        int end = (i + chunkSize < originalArray.length)
            ? i + chunkSize
            : originalArray.length;
        result.add(originalArray.sublist(i, end));
      }

      return result;
    }

    result = breakArray(chapterLines, linesPerPage);
    return result;
  }
}
