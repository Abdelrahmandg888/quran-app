class Moshaf {
  final int id;
  final String name;
  final int rewayaId;
  final String server;
  final int surahTotal;
  final String surahList;

  Moshaf({
    required this.id,
    required this.name,
    required this.rewayaId,
    required this.server,
    required this.surahTotal,
    required this.surahList,
  });

  factory Moshaf.fromJson(Map<String, dynamic> json) {
    return Moshaf(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      rewayaId: json['rewaya'] ?? 0,
      server: (json['server'] ?? '').toString().trim(),
      surahTotal: json['surah_total'] ?? 0,
      surahList: json['surah_list'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'rewaya': rewayaId,
        'server': server,
        'surah_total': surahTotal,
        'surah_list': surahList,
      };

  List<int> get availableSurahIds {
    if (surahList.isEmpty) return [];
    return surahList
        .split(',')
        .map((s) => int.tryParse(s.trim()) ?? 0)
        .where((id) => id > 0)
        .toList();
  }

  String getAudioUrl(int surahId) {
    final cleanServer = server.trim();
    final paddedSurah = surahId.toString().padLeft(3, '0');
    final formattedServer = cleanServer.endsWith('/') ? cleanServer : '$cleanServer/';
    return '$formattedServer$paddedSurah.mp3';
  }
}

class Reciter {
  final int id;
  final String name;
  final String letter;
  final List<Moshaf> moshaf;

  Reciter({
    required this.id,
    required this.name,
    required this.letter,
    required this.moshaf,
  });

  factory Reciter.fromJson(Map<String, dynamic> json) {
    var moshafJson = json['moshaf'] as List? ?? [];
    List<Moshaf> moshafList =
        moshafJson.map((m) => Moshaf.fromJson(m)).toList();

    return Reciter(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      letter: json['letter'] ?? '',
      moshaf: moshafList,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'letter': letter,
        'moshaf': moshaf.map((m) => m.toJson()).toList(),
      };
}
