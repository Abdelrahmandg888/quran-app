class Surah {
  final int id;
  final String name;
  final int startPage;
  final int endPage;
  final bool isMakki;

  Surah({
    required this.id,
    required this.name,
    required this.startPage,
    required this.endPage,
    required this.isMakki,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      startPage: json['start_page'] ?? 0,
      endPage: json['end_page'] ?? 0,
      isMakki: (json['makkia'] ?? 1) == 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'start_page': startPage,
        'end_page': endPage,
        'makkia': isMakki ? 1 : 0,
      };

  String get formattedNumber => id.toString().padLeft(3, '0');
  
  String get typeName => isMakki ? 'مكية' : 'مدنية';
}
