import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:universal_io/io.dart' as io;

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../models/saved_book.dart';
import '../database/database.dart';

class BookProvider extends ChangeNotifier {
  final AppDatabase _db;
  List<SavedBook> _savedBooks = [];
  bool _isLoading = true;
  bool _isGridView = true;
  String _searchQuery = '';

  List<SavedBook> get savedBooks => _savedBooks;
  bool get isLoading => _isLoading;
  bool get isGridView => _isGridView;
  String get searchQuery => _searchQuery;

  BookProvider(this._db) {
    _init();
  }

  Future<void> _init() async {
    await loadSavedBooks();
    await _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final settings = await _db.select(_db.settings).get();
      final map = {for (var s in settings) s.key: s.value};
      if (map.containsKey('isGridView')) {
        _isGridView = map['isGridView'] == 'true';
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Tercihler yüklenirken hata: $e');
    }
  }

  Future<void> setGridView(bool value) async {
    if (_isGridView != value) {
      _isGridView = value;
      notifyListeners();
      try {
        await _db
            .into(_db.settings)
            .insertOnConflictUpdate(
              SettingsCompanion.insert(
                key: 'isGridView',
                value: value.toString(),
              ),
            );
      } catch (e) {
        debugPrint('GridView tercihi kaydedilemedi: $e');
      }
    }
  }

  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  Future<String> saveCoverImage(
    String bookId,
    Uint8List imageBytes, {
    String? oldPath,
  }) async {
    if (kIsWeb) {
      return 'data:image/png;base64,${base64Encode(imageBytes)}';
    }
    try {
      if (oldPath != null) {
        final oldFile = io.File(oldPath);
        if (await oldFile.exists()) {
          await oldFile.delete();
        }
      }

      final docsDir = await getApplicationSupportDirectory();
      final coversPath = p.join(docsDir.path, 'book_covers');
      final coversDir = io.Directory(coversPath);
      if (!await coversDir.exists()) {
        await coversDir.create(recursive: true);
      }

      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${bookId}_cover_$timestamp.png';
      final filePath = p.join(coversPath, fileName);
      await io.File(filePath).writeAsBytes(imageBytes);
      return filePath;
    } catch (e) {
      debugPrint('Kapak resmi kaydedilemedi: $e');
      throw Exception('Kapak resmi kaydedilemedi');
    }
  }

  Future<void> deleteImage(String? filePath) async {
    if (kIsWeb || filePath == null || filePath.isEmpty) return;
    try {
      final file = io.File(filePath);
      if (await file.exists()) {
        await file.delete();
      }
    } catch (e) {
      debugPrint('Dosya silinirken hata: $e');
    }
  }

  Future<void> cleanupOrphanedCovers() async {
    if (kIsWeb) return;
    try {
      final docsDir = await getApplicationSupportDirectory();
      final coversPath = p.join(docsDir.path, 'book_covers');
      final coversDir = io.Directory(coversPath);
      if (!await coversDir.exists()) return;

      final usedFiles = <String>{};
      for (var book in _savedBooks) {
        if (book.coverImage != null)
          usedFiles.add(p.canonicalize(book.coverImage!));
        if (book.originalCoverImage != null)
          usedFiles.add(p.canonicalize(book.originalCoverImage!));
      }

      final files = coversDir.listSync();
      for (var file in files) {
        if (file is io.File) {
          final path = p.canonicalize(file.path);
          if (!usedFiles.contains(path)) {
            debugPrint('Yetim dosya siliniyor: $path');
            await file.delete();
          }
        }
      }
    } catch (e) {
      debugPrint('Yetim dosyalar temizlenirken hata: $e');
    }
  }

  Future<void> loadSavedBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final books = await (_db.select(
        _db.books,
      )..orderBy([(t) => OrderingTerm(expression: t.position)])).get();

      _savedBooks = books
          .map(
            (b) => SavedBook(
              id: b.id,
              name: b.name,
              sourceId: b.sourceId,
              baseUrl: b.baseUrl,
              addedDate: b.addedDate,
              coverImage: b.coverImage,
              originalCoverImage: b.originalCoverImage,
              sourceType: b.scraperType,
            ),
          )
          .toList();

      cleanupOrphanedCovers();
    } catch (e) {
      debugPrint('Kitaplar yüklenirken hata: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addBook(SavedBook book) async {
    try {
      await _db
          .into(_db.books)
          .insert(
            BooksCompanion.insert(
              id: book.id,
              name: book.name,
              sourceId: book.sourceId,
              baseUrl: book.baseUrl,
              addedDate: book.addedDate,
              coverImage: Value(book.coverImage),
              originalCoverImage: Value(book.originalCoverImage),
              position: Value(_savedBooks.length),
              scraperType: Value(book.sourceType),
            ),
          );
      await loadSavedBooks();
    } catch (e) {
      debugPrint('Kitap eklenirken hata: $e');
    }
  }

  Future<void> deleteBook(SavedBook book) async {
    try {
      if (!kIsWeb) {
        if (book.coverImage != null) {
          final file = io.File(book.coverImage!);
          if (await file.exists()) {
            await file.delete();
          }
        }
        if (book.originalCoverImage != null) {
          final file = io.File(book.originalCoverImage!);
          if (await file.exists()) {
            await file.delete();
          }
        }
      }

      await (_db.delete(_db.books)..where((t) => t.id.equals(book.id))).go();
      await loadSavedBooks();
    } catch (e) {
      debugPrint('Kitap silinirken hata: $e');
    }
  }

  Future<void> updateBook(SavedBook book) async {
    try {
      await (_db.update(_db.books)..where((t) => t.id.equals(book.id))).write(
        BooksCompanion(
          name: Value(book.name),
          coverImage: Value(book.coverImage),
          originalCoverImage: Value(book.originalCoverImage),
        ),
      );
      await loadSavedBooks();
    } catch (e) {
      debugPrint('Kitap güncellenirken hata: $e');
    }
  }

  Future<void> reorderBooks(int oldIndex, int newIndex) async {
    try {
      if (oldIndex < newIndex) {
        newIndex -= 1;
      }
      final SavedBook item = _savedBooks.removeAt(oldIndex);
      _savedBooks.insert(newIndex, item);

      await _db.transaction(() async {
        for (int i = 0; i < _savedBooks.length; i++) {
          await (_db.update(_db.books)
                ..where((t) => t.id.equals(_savedBooks[i].id)))
              .write(BooksCompanion(position: Value(i)));
        }
      });

      notifyListeners();
    } catch (e) {
      debugPrint('Sıralama değiştirilirken hata: $e');
      await loadSavedBooks();
    }
  }
}
