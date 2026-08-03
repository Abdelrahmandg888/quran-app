import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DownloadedItem {
  final int reciterId;
  final String reciterName;
  final int moshafId;
  final String moshafName;
  final int surahId;
  final String surahName;
  final String localPath;
  final int fileSize;
  final DateTime downloadedAt;

  DownloadedItem({
    required this.reciterId,
    required this.reciterName,
    required this.moshafId,
    required this.moshafName,
    required this.surahId,
    required this.surahName,
    required this.localPath,
    required this.fileSize,
    required this.downloadedAt,
  });

  String get key => '${reciterId}_${moshafId}_$surahId';

  Map<String, dynamic> toJson() => {
        'reciterId': reciterId,
        'reciterName': reciterName,
        'moshafId': moshafId,
        'moshafName': moshafName,
        'surahId': surahId,
        'surahName': surahName,
        'localPath': localPath,
        'fileSize': fileSize,
        'downloadedAt': downloadedAt.toIso8601String(),
      };

  factory DownloadedItem.fromJson(Map<String, dynamic> json) {
    return DownloadedItem(
      reciterId: json['reciterId'] ?? 0,
      reciterName: json['reciterName'] ?? '',
      moshafId: json['moshafId'] ?? 0,
      moshafName: json['moshafName'] ?? '',
      surahId: json['surahId'] ?? 0,
      surahName: json['surahName'] ?? '',
      localPath: json['localPath'] ?? '',
      fileSize: json['fileSize'] ?? 0,
      downloadedAt: DateTime.tryParse(json['downloadedAt'] ?? '') ?? DateTime.now(),
    );
  }
}

class DownloadService {
  static final DownloadService _instance = DownloadService._internal();
  factory DownloadService() => _instance;

  final Dio _dio = Dio();
  static const String _storageKey = 'quran_downloads_metadata';

  DownloadService._internal();

  Future<String> get _downloadDir async {
    final docs = await getApplicationDocumentsDirectory();
    final dir = Directory('${docs.path}/quran_audio');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir.path;
  }

  Future<DownloadedItem?> downloadSurah({
    required String audioUrl,
    required int reciterId,
    required String reciterName,
    required int moshafId,
    required String moshafName,
    required int surahId,
    required String surahName,
    required Function(double progress) onProgress,
    CancelToken? cancelToken,
  }) async {
    final dirPath = await _downloadDir;
    final fileName = '${reciterId}_${moshafId}_${surahId.toString().padLeft(3, '0')}.mp3';
    final savePath = '$dirPath/$fileName';

    try {
      await _dio.download(
        audioUrl,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            onProgress(received / total);
          }
        },
        cancelToken: cancelToken,
      );

      final file = File(savePath);
      final size = await file.length();

      final item = DownloadedItem(
        reciterId: reciterId,
        reciterName: reciterName,
        moshafId: moshafId,
        moshafName: moshafName,
        surahId: surahId,
        surahName: surahName,
        localPath: savePath,
        fileSize: size,
        downloadedAt: DateTime.now(),
      );

      await saveDownloadMetadata(item);
      return item;
    } catch (e) {
      // Clean up partial file if failed
      final file = File(savePath);
      if (await file.exists()) {
        await file.delete();
      }
      rethrow;
    }
  }

  Future<List<DownloadedItem>> loadAllDownloads() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_storageKey);
    if (jsonStr == null) return [];

    try {
      final List decoded = json.decode(jsonStr);
      final items = <DownloadedItem>[];
      for (var itemMap in decoded) {
        final item = DownloadedItem.fromJson(itemMap);
        if (await File(item.localPath).exists()) {
          items.add(item);
        }
      }
      return items;
    } catch (e) {
      return [];
    }
  }

  Future<void> saveDownloadMetadata(DownloadedItem item) async {
    final downloads = await loadAllDownloads();
    downloads.removeWhere((d) => d.key == item.key);
    downloads.add(item);

    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(downloads.map((d) => d.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  Future<void> deleteDownload(DownloadedItem item) async {
    final file = File(item.localPath);
    if (await file.exists()) {
      await file.delete();
    }

    final downloads = await loadAllDownloads();
    downloads.removeWhere((d) => d.key == item.key);

    final prefs = await SharedPreferences.getInstance();
    final jsonStr = json.encode(downloads.map((d) => d.toJson()).toList());
    await prefs.setString(_storageKey, jsonStr);
  }

  Future<void> deleteAllDownloads() async {
    final downloads = await loadAllDownloads();
    for (var item in downloads) {
      final file = File(item.localPath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}
