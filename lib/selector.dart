import 'dart:io';
import 'package:epubx/epubx.dart';
import 'package:terminal_reader/widgets/selector/selector.dart';
import 'package:terminal_reader/widgets/widget.dart';

class Selector extends Widget {
  List<EpubBook> books = [];
  late BookSelector selectorWidget;
  Selector();

  Future<void> fillBooks(String path) async {
    var entities = await Directory(path).list().toList();
    var files = entities.whereType<File>();
    for (var file in files) {
      if (file.path.split('/').last.split('.').last == 'epub') {
        var book = await EpubReader.readBook(file.readAsBytesSync());
        books.add(book);
      }
    }

    selectorWidget = BookSelector(books);
  }

  void listen(int key) {
    selectorWidget.listen(key);
  }

  @override
  void build() {
    selectorWidget.build();
  }
}
