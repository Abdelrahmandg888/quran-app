class RadioStation {
  final int id;
  final String name;
  final String url;
  final String recentDate;

  RadioStation({
    required this.id,
    required this.name,
    required this.url,
    required this.recentDate,
  });

  factory RadioStation.fromJson(Map<String, dynamic> json) {
    return RadioStation(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      url: json['url'] ?? '',
      recentDate: json['recent_date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'url': url,
        'recent_date': recentDate,
      };
}
