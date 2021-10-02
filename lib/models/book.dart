import 'dart:async';

import 'package:audiobooks_app/models/book_file.dart';
import 'package:audiobooks_app/models/server.dart';
import 'package:rxdart/rxdart.dart';

class Book {
  final int id;
  final String seriesTitle;
  final String title;
  final String imageUrl;
  final Duration duration;
  final String description;
  final int ageRating;
  final List<LANGUAGES> languages;
  final String author;
  final int year;
  final String filePath;
  final int amountOfParts;
  final String coverUrl;
  final bool local;
  final List<String> tags;
  final BehaviorSubject<int> _fileSizeChanges = BehaviorSubject<int>();
  late ValueStream<int> fileSizeChanges;

  String get localImageUrl {
    return local ? "assets/$imageUrl" : "$URL_PREFIX$imageUrl";
  }

  String get remoteImageUrl {
    return local ? "$URL_PREFIX/$imageUrl" : "https://$URL_PREFIX$imageUrl";
  }

  late List<BookFile> files;

  Book({
    required this.id,
    required this.seriesTitle,
    required this.title,
    required this.imageUrl,
    required this.duration,
    required this.description,
    required this.ageRating,
    required this.languages,
    required this.author,
    required this.year,
    required this.filePath,
    required this.amountOfParts,
    required this.coverUrl,
    this.local = true,
    required this.tags,
  }) {
    files = Iterable<int>.generate(amountOfParts).map((index) {
      if (index == 0) {
        return BookFile(title: "Передмова", url: "$filePath/pre.mp3");
      } else {
        return BookFile(title: "Розділ $index", url: "$filePath/$index.mp3");
      }
    }).toList();

    fileSizeChanges = _fileSizeChanges.stream;
    recalculateFileSize();
  }

  Future<void> downloadBook() async {
    final statuses = _downloadFiles();
    var size = 0;
    await for (var fileSize in statuses) {
      size += fileSize;
      _fileSizeChanges.add(size);
    }
  }

  Stream<int> _downloadFiles() async* {
    for (var file in files) {
      await file.saveForOffline();
      var size = await file.downloadedFileSize();
      yield size;
    }
  }

  factory Book.fromJson(Map<String, dynamic> json) {
    final List tagsJson = json["tags"];
    return Book(
      id: json["id"],
      seriesTitle: json["series"],
      title: json["title"],
      imageUrl: json["imageUrl"],
      duration: Duration(minutes: json["duration"]),
      year: json["year"],
      description: json["description"],
      ageRating: json["ageRating"],
      languages: [LANGUAGES.UKR],
      filePath: json["filesPath"],
      amountOfParts: json["amountOfParts"],
      local: false,
      author: json["author"],
      coverUrl: json["imageUrl"],
      tags: tagsJson.map<String>((tagJson) => tagJson).toList(),
    );
  }

  Future removeDownloads() async {
    await Future.forEach<BookFile>(files, (file) async {
      await file.removeDownload();
    });

    recalculateFileSize();
  }

  Future recalculateFileSize() async {
    var size = await totalFileSize();
    _fileSizeChanges.add(size);
  }

  Future<int> totalFileSize() async {
    var size = 0;
    await Future.forEach<BookFile>(files, (file) async {
      var s = await file.downloadedFileSize();
      size = size + s;
    });
    return size;
  }
}

List<Book> generateLocalBooks() {
  return [
    Book(
      id: 1,
      seriesTitle: "Minecraft",
      title: "Ніч кажанів",
      imageUrl: "minecraft/night_of_the_bats/cover.png",
      coverUrl: "minecraft/night_of_the_bats/cover.png",
      duration: Duration(minutes: 45),
      description:
          "Зомбі вже близько... а з ними й кажани! Коли орда зомбі атакує їхнє селище у Майнкрафті, а зграя кажанів зриває уроки в школі, наші п'ятеро гравців задаються питанням: хто стоїть за цим нашестям монстрів... і чи скасували на сьогодні математику?",
      ageRating: 7,
      languages: [LANGUAGES.UKR],
      author: "Нік Еліопулос",
      year: 2020,
      filePath: "minecraft/night_of_the_bats",
      amountOfParts: 15,
      tags: ["майнкрафт"],
    ),
    Book(
      id: 2,
      seriesTitle: "Minecraft",
      title: "Глибоке занурення",
      imageUrl: "minecraft/deep_dive/cover.png",
      duration: Duration(minutes: 42),
      coverUrl: "/minecraft/deep_dive/cover.png",
      description:
          "Пригоди тривають у третій книзі офіційної серії «Майнкрафт. Хроніки Вудсворду» за сюжетом найпопулярнішої гри всіх часів! Цього разу на Еш, Морґана і трьох їхніх однокласників чекає глибоке занурення у водному біомі.  Незвідані глибини ваблять красою і дивами, а карта скарбів обіцяє незабутні пригоди... А раптом це пастка загадкового Короля кликунів? Повітря дедалі менше — чи вдасться друзям вижити й розкрити таємницю?",
      ageRating: 7,
      languages: [LANGUAGES.UKR],
      author: "Нік Еліопулос",
      year: 2020,
      filePath: "minecraft/deep_dive",
      amountOfParts: 16,
      tags: ["майнкрафт"],
    ),
    Book(
      id: 3,
      seriesTitle: "Minecraft",
      title: "Цифрова загроза",
      author: "Нік Еліопулос",
      year: 2020,
      imageUrl: "minecraft/cifrova_zagroza/cover.png",
      coverUrl: "minecraft/cifrova_zagroza/cover.png",
      duration: Duration(minutes: 53),
      description:
          """Четверта книга неймовірних пригод в офіційній серії «Майнкрафт. Хроніки Вудсворду»! У попередній книзі історія об
      ривається на найцікавішому місці... Що робитимуть друзі, о
      пинившись у небезпечній ситуації? Хто ж усе-таки розставляє усі ці пастки та називає себе Королем кликунів? Тим часом
      на Вудсворд насувається цифрова загроза...""",
      ageRating: 7,
      languages: [
        LANGUAGES.UKR,
      ],
      filePath: "minecraft/cifrova_zagroza",
      amountOfParts: 16,
      tags: ["майнкрайфт"],
    ),
    Book(
      id: 4,
      seriesTitle: "Minecraft",
      title: "Таємниця підземелля",
      author: "Нік Еліопулос",
      year: 2020,
      imageUrl: "minecraft/dungeon_secrets/cover.png",
      coverUrl: "minecraft/dungeon_secrets/cover.png",
      duration: Duration(minutes: 42),
      description:
          """П'ята книжка з серії «Майнкрафт. Хроніки Вудсворду». Що яскравішим буде світло прожекторів... То глибшим стане підземелля! Доки усі метушаться, готуючись до шкільної п’єси, у По та його друзів є серйозніші проблеми. Їм треба знайти джерело сили Короля кликунів, сховане у страшному підземеллі… Але що глибше друзі копають, то все більше їм здається, що хтось скеровує кожен їхній крок.""",
      ageRating: 7,
      languages: [
        LANGUAGES.UKR,
      ],
      filePath: "minecraft/dungeon_secrets",
      amountOfParts: 15,
      tags: ["майнкрафт"],
    ),
  ];
}

enum LANGUAGES { UKR, RUS }

List<LANGUAGES> languagesFromStrings(List<String> langs) {
  return langs.map((sLang) {
    if (sLang == "UKR") {
      return LANGUAGES.UKR;
    } else {
      return LANGUAGES.RUS;
    }
  }).toList();
}
