import 'package:flutter_test/flutter_test.dart';
import 'package:quran/models/reciter.dart';
import 'package:quran/models/radio_station.dart';
import 'package:quran/models/surah.dart';

void main() {
  group('Model Serialization Tests', () {
    test('Reciter and Moshaf model parsing and audio URL construction', () {
      final json = {
        'id': 1,
        'name': 'عبد الباسط عبد الصمد',
        'letter': 'ع',
        'moshaf': [
          {
            'id': 1,
            'name': 'حفص عن عاصم',
            'rewaya': 1,
            'server': 'https://server8.mp3quran.net/afs/',
            'surah_total': 114,
            'surah_list': '1,2,3,4,114',
          }
        ]
      };

      final reciter = Reciter.fromJson(json);
      expect(reciter.id, 1);
      expect(reciter.name, 'عبد الباسط عبد الصمد');
      expect(reciter.moshaf.length, 1);

      final moshaf = reciter.moshaf.first;
      expect(moshaf.availableSurahIds, [1, 2, 3, 4, 114]);
      expect(moshaf.getAudioUrl(1), 'https://server8.mp3quran.net/afs/001.mp3');
      expect(moshaf.getAudioUrl(114), 'https://server8.mp3quran.net/afs/114.mp3');
    });

    test('RadioStation model parsing', () {
      final json = {
        'id': 1,
        'name': 'إذاعة القاهرة',
        'url': 'https://stream.radiojar.com/8smy15twv1tuv',
        'recent_date': '2026-01-01',
      };

      final radio = RadioStation.fromJson(json);
      expect(radio.id, 1);
      expect(radio.name, 'إذاعة القاهرة');
      expect(radio.url, 'https://stream.radiojar.com/8smy15twv1tuv');
    });

    test('Surah model parsing', () {
      final json = {
        'id': 1,
        'name': 'الفاتحة',
        'start_page': 1,
        'end_page': 1,
        'makkia': 1,
      };

      final surah = Surah.fromJson(json);
      expect(surah.id, 1);
      expect(surah.name, 'الفاتحة');
      expect(surah.formattedNumber, '001');
      expect(surah.isMakki, isTrue);
      expect(surah.typeName, 'مكية');
    });
  });
}
