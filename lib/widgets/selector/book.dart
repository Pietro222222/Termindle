import 'dart:io';

import 'package:epubx/epubx.dart';
import 'package:terminal_reader/widgets/widget.dart';

class BookWidget extends Widget {
  EpubBook book;
  BookWidget(this.book);

  @override
  void build() {
    stdout.write(
        '\r${book.Title!} ${book.Author != null ? "by ${book.Author!}" : ""}\n');
  }
}
