import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/reciter.dart';
import '../models/surah.dart';

class RecitersProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Reciter> _allReciters = [];
  List<Reciter> _filteredReciters = [];
  List<Reciter> get reciters => _filteredReciters;

  List<Surah> _allSuwar = [];
  List<Surah> get suwar => _allSuwar;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  int? _selectedRewayaFilter;
  int? get selectedRewayaFilter => _selectedRewayaFilter;

  Reciter? _selectedReciter;
  Reciter? get selectedReciter => _selectedReciter;

  Moshaf? _selectedMoshaf;
  Moshaf? get selectedMoshaf => _selectedMoshaf;

  RecitersProvider() {
    loadData();
  }

  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _apiService.fetchReciters(language: 'ar'),
        _apiService.fetchSuwar(language: 'ar'),
      ]);

      _allReciters = results[0] as List<Reciter>;
      _allSuwar = results[1] as List<Surah>;
      _applyFilters();
    } catch (e) {
      _error = 'حدث خطأ أثناء تحميل البيانات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
  }

  void filterByRewaya(int? rewayaId) {
    _selectedRewayaFilter = rewayaId;
    _applyFilters();
  }

  void _applyFilters() {
    _filteredReciters = _allReciters.where((reciter) {
      final matchesSearch = _searchQuery.isEmpty ||
          reciter.name.contains(_searchQuery) ||
          reciter.letter.contains(_searchQuery);

      final matchesRewaya = _selectedRewayaFilter == null ||
          reciter.moshaf.any((m) => m.rewayaId == _selectedRewayaFilter);

      return matchesSearch && matchesRewaya;
    }).toList();

    notifyListeners();
  }

  void selectReciter(Reciter reciter, {Moshaf? moshaf}) {
    _selectedReciter = reciter;
    _selectedMoshaf = moshaf ?? (reciter.moshaf.isNotEmpty ? reciter.moshaf.first : null);
    notifyListeners();
  }

  void selectMoshaf(Moshaf moshaf) {
    _selectedMoshaf = moshaf;
    notifyListeners();
  }

  Surah? getSurahById(int id) {
    try {
      return _allSuwar.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  List<Surah> getAvailableSurahsForSelectedMoshaf() {
    if (_selectedMoshaf == null) return [];
    final availableIds = _selectedMoshaf!.availableSurahIds;
    return _allSuwar.where((s) => availableIds.contains(s.id)).toList();
  }
}
