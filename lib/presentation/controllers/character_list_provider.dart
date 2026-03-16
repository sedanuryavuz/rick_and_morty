import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/enums/character_status.dart';
import '../../data/models/character_model.dart';
import '../../data/repositories/character_repository.dart';

class CharacterListProvider extends ChangeNotifier {
  final CharacterRepository repository;

  CharacterListProvider(this.repository);

  final List<CharacterStatus> filters = CharacterStatus.values;

  List<CharacterModel> _characters = [];
  List<CharacterModel> get characters => _characters;

  int _selectedFilterIndex = 0;
  int get selectedFilterIndex => _selectedFilterIndex;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  bool _isInitialLoading = true;
  bool get isInitialLoading => _isInitialLoading;

  bool _isPaginationLoading = false;
  bool get isPaginationLoading => _isPaginationLoading;

  bool _isRefreshing = false;
  bool get isRefreshing => _isRefreshing;

  bool _hasMore = true;
  bool get hasMore => _hasMore;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  int _currentPage = 1;
  int get currentPage => _currentPage;

  int _totalCount = 0;
  int get totalCount => _totalCount;

  Timer? _debounce;

  Future<void> loadInitialCharacters() async {
    final bool firstLoad = _characters.isEmpty;

    if (firstLoad) {
      _isInitialLoading = true;
    } else {
      _isRefreshing = true;
    }

    _errorMessage = null;
    _currentPage = 1;
    _hasMore = true;
    notifyListeners();

    try {
      final response = await repository.getCharacters(
        page: 1,
        name: _searchQuery.trim(),
        status: filters[_selectedFilterIndex].apiValue,
      );

      _characters = response.results;
      _totalCount = response.count;
      _currentPage = 1;
      _hasMore = response.next != null;
      _isInitialLoading = false;
      _isRefreshing = false;
      notifyListeners();
    } catch (e) {
      _characters = [];
      _totalCount = 0;
      _errorMessage = e.toString();
      _hasMore = false;
      _isInitialLoading = false;
      _isRefreshing = false;
      notifyListeners();
    }
  }

  Future<void> loadMoreCharacters() async {
    if (_isInitialLoading || _isPaginationLoading || !_hasMore) return;

    _isPaginationLoading = true;
    notifyListeners();

    final nextPage = _currentPage + 1;

    try {
      final response = await repository.getCharacters(
        page: nextPage,
        name: _searchQuery.trim(),
        status: filters[_selectedFilterIndex].apiValue,
      );

      _characters = [..._characters, ...response.results];
      _totalCount = response.count;
      _currentPage = nextPage;
      _hasMore = response.next != null;
      _isPaginationLoading = false;
      notifyListeners();
    } catch (_) {
      _isPaginationLoading = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String value) {
    _searchQuery = value;

    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      loadInitialCharacters();
    });
  }

  void onFilterChanged(int index) {
    _selectedFilterIndex = index;
    notifyListeners();
    loadInitialCharacters();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}