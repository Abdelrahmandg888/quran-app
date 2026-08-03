import 'package:dio/dio.dart';
import '../models/reciter.dart';
import '../models/radio_station.dart';
import '../models/surah.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;

  late final Dio _dio;

  ApiService._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://mp3quran.net/api/v3/',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Accept': 'application/json',
        },
      ),
    );
  }

  Future<List<Reciter>> fetchReciters({String language = 'ar'}) async {
    try {
      final response = await _dio.get(
        'reciters',
        queryParameters: {'language': language},
      );

      if (response.statusCode == 200 && response.data != null) {
        final List recitersJson = response.data['reciters'] ?? [];
        return recitersJson.map((json) => Reciter.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      // Fallback attempt to English if Arabic fails or network glitch
      if (language == 'ar') {
        try {
          final fallback = await _dio.get('reciters', queryParameters: {'language': 'en'});
          if (fallback.statusCode == 200 && fallback.data != null) {
            final List recitersJson = fallback.data['reciters'] ?? [];
            return recitersJson.map((json) => Reciter.fromJson(json)).toList();
          }
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<List<RadioStation>> fetchRadios({String language = 'ar'}) async {
    try {
      final response = await _dio.get(
        'radios',
        queryParameters: {'language': language},
      );

      if (response.statusCode == 200 && response.data != null) {
        final List radiosJson = response.data['radios'] ?? [];
        return radiosJson.map((json) => RadioStation.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Surah>> fetchSuwar({String language = 'ar'}) async {
    try {
      final response = await _dio.get(
        'suwar',
        queryParameters: {'language': language},
      );

      if (response.statusCode == 200 && response.data != null) {
        final List suwarJson = response.data['suwar'] ?? [];
        return suwarJson.map((json) => Surah.fromJson(json)).toList();
      }
      return [];
    } catch (e) {
      rethrow;
    }
  }
}
