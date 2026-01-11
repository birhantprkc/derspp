import 'package:flutter/material.dart';
import 'package:drift/drift.dart';
import '../models/book_content.dart';
import '../models/source_item.dart';
import '../services/source_factory.dart';
import '../database/database.dart';

class SourceProvider extends ChangeNotifier {
  final AppDatabase _db;
  BookContent? _currentBookContent;
  String? _baseUrl;
  String _currentSourceType = 'fsource';
  String _currentCategoryId = '5';
  String _rootCategoryId = '5';
  final List<SourceItem> _navigationStack = [];
  List<SourceItem> _currentItems = [];
  bool _isLoading = false;
  String? _errorMessage;
  final Map<String, List<SourceItem>> _categoryCache = {};

  bool _loadingPubs = true;
  List<Publisher> _savedPubs = [];

  BookContent? get currentBookContent => _currentBookContent;
  String? get baseUrl => _baseUrl;
  String get currentSourceType => _currentSourceType;
  String get currentCategoryId => _currentCategoryId;
  String get rootCategoryId => _rootCategoryId;
  List<SourceItem> get navigationStack => _navigationStack;
  List<SourceItem> get currentItems => _currentItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  List<Publisher> get savedPubs => _savedPubs;
  bool get loadingPubs => _loadingPubs;

  String get breadcrumbs => _navigationStack.map((e) => e.name).join(' > ');

  SourceProvider(this._db) {
    _init();
  }

  Future<void> _init() async {
    await loadSavedPubs();
  }

  void setBaseUrl(String? url, String rootId, {String sourceType = 'fsource'}) {
    _baseUrl = url;
    _currentSourceType = sourceType;
    _rootCategoryId = rootId;
    _currentCategoryId = rootId;
    _navigationStack.clear();
    _currentBookContent = null;
    _currentItems = [];
    _categoryCache.clear();
    _errorMessage = null;
    notifyListeners();
  }

  void setupForBook(
    String url,
    String sourceId,
    String bookName, {
    String sourceType = 'fsource',
  }) {
    _baseUrl = url;
    _currentSourceType = sourceType;
    _rootCategoryId = '5';
    _currentCategoryId = sourceId;
    _navigationStack.clear();
    _navigationStack.add(
      SourceItem(
        id: sourceId,
        name: bookName,
        isParent: true,
        parentId: _rootCategoryId,
      ),
    );
    _categoryCache.clear();
    _errorMessage = null;
    _currentBookContent = null;
    loadCategory(sourceId);
  }

  Future<void> loadSavedPubs() async {
    _loadingPubs = true;
    notifyListeners();

    try {
      final pubs = await _db.select(_db.publishers).get();
      _savedPubs = pubs;
    } catch (e) {
      debugPrint('Yayıncılar yüklenirken hata: $e');
      _errorMessage = 'Yayıncılar yüklenemedi: $e';
    } finally {
      _loadingPubs = false;
      notifyListeners();
    }
  }

  Future<void> savePub(
    String name,
    String url,
    String id, {
    String type = 'fsource',
  }) async {
    try {
      await _db
          .into(_db.publishers)
          .insert(
            PublishersCompanion.insert(
              name: name,
              url: url,
              sourceId: id,
              scraperType: Value(type),
            ),
          );
      await loadSavedPubs();
    } catch (e) {
      debugPrint('Yayıncı kaydedilirken hata: $e');
      _errorMessage = 'Kaydedilemedi: $e';
      notifyListeners();
    }
  }

  Future<void> deletePub(Publisher pub) async {
    try {
      await (_db.delete(
        _db.publishers,
      )..where((t) => t.id.equals(pub.id))).go();
      await loadSavedPubs();
    } catch (e) {
      debugPrint('Yayıncı silinirken hata: $e');
    }
  }

  Future<void> loadCategory(String id) async {
    if (_baseUrl == null) return;

    final cacheKey = '$_baseUrl|$id';

    if (_categoryCache.containsKey(cacheKey)) {
      _currentItems = _categoryCache[cacheKey]!;
      _isLoading = false;
      _errorMessage = null;
      _currentCategoryId = id;
      notifyListeners();
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    _currentCategoryId = id;
    notifyListeners();

    try {
      final sourceService = SourceFactory.getSourceService(_currentSourceType);
      final items = await sourceService.fetchSourceList(id, _baseUrl!);
      _categoryCache[cacheKey] = items;
      _currentItems = items;
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _currentItems = [];
      _isLoading = false;
    }
    notifyListeners();
  }

  Future<void> onItemTap(SourceItem item) async {
    if (item.isParent) {
      _navigationStack.add(item);
      notifyListeners();
      await loadCategory(item.id);
    } else {
      await loadTestContent(item);
    }
  }

  Future<void> loadTestContent(SourceItem item) async {
    _isLoading = true;
    _errorMessage = null;
    _currentCategoryId = item.id;
    notifyListeners();
    try {
      final sourceService = SourceFactory.getSourceService(_currentSourceType);
      final content = await sourceService.fetchBookContent(item.id, _baseUrl!);

      _currentBookContent = content;
      _currentItems = [];
      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
    }
    notifyListeners();
  }

  void navigateBack({String? initialSourceId, required VoidCallback onPop}) {
    if (_currentBookContent != null) {
      _currentBookContent = null;
      _currentItems = [];
      final targetId = _navigationStack.isEmpty
          ? _rootCategoryId
          : _navigationStack.last.id;
      loadCategory(targetId);
      return;
    }

    if (_navigationStack.isNotEmpty) {
      final last = _navigationStack.removeLast();

      if (initialSourceId != null && last.id == initialSourceId) {
        onPop();
        return;
      }

      final parentId = _navigationStack.isEmpty
          ? _rootCategoryId
          : _navigationStack.last.id;
      loadCategory(parentId);
      return;
    }

    onPop();
  }

  void pushToStack(SourceItem item) {
    _navigationStack.add(item);
    notifyListeners();
  }

  void clearCurrentBookContent() {
    _currentBookContent = null;
    notifyListeners();
  }
}
