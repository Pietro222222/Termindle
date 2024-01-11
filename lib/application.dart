import 'dart:io';

import 'package:terminal_reader/reader.dart';
import 'package:terminal_reader/selector.dart';
import 'package:terminal_reader/storage/books_info.dart';

class App {
  Selector selector;
  Reader? reader;

  bool isSelectorEnabled = true;

  App(this.selector);

  Future<void> init({String path = './books/'}) async {
    await selector.fillBooks(path);
  }

  void listen() {
    while (true) {
      var key = stdin.readByteSync();
      //pre-op
      if (key == -1) {
        continue;
      } else if (key == 16 && reader != null) {
        isSelectorEnabled = !isSelectorEnabled;
        draw();
        continue;
      }
      //op
      if (isSelectorEnabled) {
        sendToSelector(key);
        if (selector.selectorWidget.selectedBook != null) {
          reader = Reader(selector.selectorWidget.selectedBook!,
              Books.retrieveStorage('./books/storage.json'));

          isSelectorEnabled = false;
          reader!.build();

          selector.selectorWidget.selectedBook = null;
        }
      } else {
        sendToReader(key);
      }
      //post-op (esc/fn + esc)
      if (key == 27) {
        if (reader != null) {
          reader!.saveInfo();
        }
        break;
      }
      draw();
    }
  }

  void sendToSelector(int key) {
    selector.listen(key);
  }

  void sendToReader(int key) {
    reader!.listen(key);
  }

  void draw() {
    if (isSelectorEnabled) {
      selector.build();
      return;
    }
    reader!.build();
  }
}
