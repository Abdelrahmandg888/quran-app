import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/radio_station.dart';

class RadioProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<RadioStation> _allRadios = [];
  List<RadioStation> _filteredRadios = [];
  List<RadioStation> get radios => _filteredRadios;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  RadioProvider() {
    loadRadios();
  }

  Future<void> loadRadios() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _allRadios = await _apiService.fetchRadios(language: 'ar');
      _applyFilter();
    } catch (e) {
      _error = 'حدث خطأ في تحميل الإذاعات: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilter();
  }

  void _applyFilter() {
    if (_searchQuery.isEmpty) {
      _filteredRadios = List.from(_allRadios);
    } else {
      _filteredRadios = _allRadios
          .where((r) => r.name.contains(_searchQuery))
          .toList();
    }
    notifyListeners();
  }

  RadioStation? get featuredRadio {
    if (_allRadios.isEmpty) return null;
    return _allRadios.firstWhere(
      (r) => r.name.contains('القاهرة') || r.name.contains('مصر') || r.name.contains('مكة'),
      orElse: () => _allRadios.first,
    );
  }
}
