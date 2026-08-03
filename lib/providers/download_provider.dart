import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import '../services/download_service.dart';

class ActiveDownload {
  final String key;
  final String title;
  final String reciterName;
  double progress;
  final CancelToken cancelToken;

  ActiveDownload({
    required this.key,
    required this.title,
    required this.reciterName,
    this.progress = 0.0,
    required this.cancelToken,
  });
}

class DownloadProvider extends ChangeNotifier {
  final DownloadService _service = DownloadService();

  List<DownloadedItem> _downloads = [];
  List<DownloadedItem> get downloads => _downloads;

  final Map<String, ActiveDownload> _activeDownloads = {};
  Map<String, ActiveDownload> get activeDownloads => _activeDownloads;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  DownloadProvider() {
    loadDownloads();
  }

  Future<void> loadDownloads() async {
    _isLoading = true;
    notifyListeners();

    _downloads = await _service.loadAllDownloads();

    _isLoading = false;
    notifyListeners();
  }

  bool isDownloaded(int reciterId, int moshafId, int surahId) {
    final key = '${reciterId}_${moshafId}_$surahId';
    return _downloads.any((d) => d.key == key);
  }

  DownloadedItem? getDownloadedItem(int reciterId, int moshafId, int surahId) {
    final key = '${reciterId}_${moshafId}_$surahId';
    try {
      return _downloads.firstWhere((d) => d.key == key);
    } catch (_) {
      return null;
    }
  }

  bool isDownloading(int reciterId, int moshafId, int surahId) {
    final key = '${reciterId}_${moshafId}_$surahId';
    return _activeDownloads.containsKey(key);
  }

  double getDownloadProgress(int reciterId, int moshafId, int surahId) {
    final key = '${reciterId}_${moshafId}_$surahId';
    return _activeDownloads[key]?.progress ?? 0.0;
  }

  Future<void> startDownload({
    required String audioUrl,
    required int reciterId,
    required String reciterName,
    required int moshafId,
    required String moshafName,
    required int surahId,
    required String surahName,
  }) async {
    final key = '${reciterId}_${moshafId}_$surahId';
    if (_activeDownloads.containsKey(key)) return;

    final cancelToken = CancelToken();
    final active = ActiveDownload(
      key: key,
      title: 'سورة $surahName',
      reciterName: reciterName,
      cancelToken: cancelToken,
    );

    _activeDownloads[key] = active;
    notifyListeners();

    try {
      final downloadedItem = await _service.downloadSurah(
        audioUrl: audioUrl,
        reciterId: reciterId,
        reciterName: reciterName,
        moshafId: moshafId,
        moshafName: moshafName,
        surahId: surahId,
        surahName: surahName,
        onProgress: (prog) {
          active.progress = prog;
          notifyListeners();
        },
        cancelToken: cancelToken,
      );

      if (downloadedItem != null) {
        _downloads.add(downloadedItem);
      }
    } catch (e) {
      debugPrint('Download error: $e');
    } finally {
      _activeDownloads.remove(key);
      notifyListeners();
    }
  }

  void cancelDownload(int reciterId, int moshafId, int surahId) {
    final key = '${reciterId}_${moshafId}_$surahId';
    final active = _activeDownloads[key];
    if (active != null) {
      active.cancelToken.cancel('User cancelled download');
      _activeDownloads.remove(key);
      notifyListeners();
    }
  }

  Future<void> deleteDownload(DownloadedItem item) async {
    await _service.deleteDownload(item);
    _downloads.removeWhere((d) => d.key == item.key);
    notifyListeners();
  }

  Future<void> deleteAll() async {
    await _service.deleteAllDownloads();
    _downloads.clear();
    notifyListeners();
  }

  int get totalStorageBytes {
    return _downloads.fold(0, (sum, item) => sum + item.fileSize);
  }

  String get formattedTotalStorage {
    final mb = totalStorageBytes / (1024 * 1024);
    if (mb > 1024) {
      return '${(mb / 1024).toStringAsFixed(1)} GB';
    }
    return '${mb.toStringAsFixed(1)} MB';
  }
}
