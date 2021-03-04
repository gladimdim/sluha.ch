import 'package:audiobooks_app/models/book_file.dart';

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

  List<BookFile> files;

  Book(
      {this.id,
      this.seriesTitle,
      this.title,
      this.imageUrl,
      this.duration,
      this.description,
      this.ageRating,
      this.languages,
      this.author,
      this.year,
      this.filePath,
      this.amountOfParts, this.coverUrl}) {
    files = Iterable<int>.generate(amountOfParts).map((index) {
      if (index == 0) {
        return BookFile(title: "Передмова", url: "$filePath/pre.mp3");
      } else {
        return BookFile(title: "Розділ $index", url: "$filePath/$index.mp3");
      }
    }).toList();
  }
}

List<Book> generateBooks() {
  return [
    Book(
      id: 1,
      seriesTitle: "Minecraft",
      title: "Ніч кажанів",
      imageUrl: "assets/minecraft/night_of_the_bats/cover.png",
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
    ),
    Book(
      id: 2,
      seriesTitle: "Minecraft",
      title: "Глибоке занурення",
      imageUrl: "assets/minecraft/deep_dive/cover.png",
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
    ),
    Book(
      id: 3,
      seriesTitle: "Minecraft",
      title: "Цифрова загроза",
      author: "Нік Еліопулос",
      year: 2020,
      imageUrl: "assets/minecraft/cifrova_zagroza/cover.png",
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
    ),
    Book(
      id: 4,
      seriesTitle: "Minecraft",
      title: "Таємниця підземелля",
      author: "Нік Еліопулос",
      year: 2020,
      imageUrl: "assets/minecraft/dungeon_secrets/cover.png",
      coverUrl: "minecraft/dungeon_secrets/cover.png",
      duration: Duration(minutes: 42),
      description:
          """П'ята книжка з серії «Майнкрафт. Хроніки Вудсворду». Що яскравішим буде світло прожекторів... То глибшим стане підземелля! Доки усі метушаться, готуючись до шкільної п’єси, у По та його друзів є серйозніші проблеми. Їм треба знайти джерело сили Короля кликунів, сховане у страшному підземеллі… Але що глибше друзі копають, то все більше їм здається, що хтось скеровує кожен їхній крок.""",
      ageRating: 7,
      languages: [
        LANGUAGES.UKR,
      ],
      filePath: "minecraft/dungeon_secrets",
      amountOfParts: 13,
    ),
  ];
}

enum LANGUAGES { UKR, RUS }
