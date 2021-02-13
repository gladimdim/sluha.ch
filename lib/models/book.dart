import 'package:audiobooks_app/models/book_file.dart';

class Book {
  final int id;
  final String title;
  final String imageUrl;
  final Duration duration;
  final String description;
  final int ageRating;
  final List<LANGUAGES> languages;
  final String author;
  final int year;

  final List<BookFile> files;

  Book({
    this.id,
    this.title,
    this.imageUrl,
    this.duration,
    this.description,
    this.ageRating,
    this.languages,
    this.files,
    this.author,
    this.year,
  });
}

List<Book> generateBooks() {
  return [
    Book(
        id: 1,
        title: "Minecraft. Ніч кажанів",
        imageUrl: "assets/minecraft/night_of_the_bats/cover.png",
        duration: Duration(minutes: 45),
        description:
            "Зомбі вже близько... а з ними й кажани! Коли орда зомбі атакує їхнє селище у Майнкрафті, а зграя кажанів зриває уроки в школі, наші п'ятеро гравців задаються питанням: хто стоїть за цим нашестям монстрів... і чи скасували на сьогодні математику?",
        ageRating: 7,
        languages: [LANGUAGES.UKR],
        author: "Нік Еліопулос",
        year: 2020,
        files: [
          BookFile(
              title: "Передмова", url: "/minecraft/night_of_the_bats/pre.mp3"),
          BookFile(
              title: "Розділ 1", url: "/minecraft/night_of_the_bats/1.mp3"),
          BookFile(
              title: "Розділ 2", url: "/minecraft/night_of_the_bats/2.mp3"),
          BookFile(
              title: "Розділ 3", url: "/minecraft/night_of_the_bats/3.mp3"),
          BookFile(
              title: "Розділ 4", url: "/minecraft/night_of_the_bats/4.mp3"),
        ]),
    Book(
        id: 2,
        title: "Minecraft. Глибоке занурення",
        imageUrl: "assets/minecraft/deep_dive/cover.png",
        duration: Duration(minutes: 42),
        description:
            "Пригоди тривають у третій книзі офіційної серії «Майнкрафт. Хроніки Вудсворду» за сюжетом найпопулярнішої гри всіх часів! Цього разу на Еш, Морґана і трьох їхніх однокласників чекає глибоке занурення у водному біомі.  Незвідані глибини ваблять красою і дивами, а карта скарбів обіцяє незабутні пригоди... А раптом це пастка загадкового Короля кликунів? Повітря дедалі менше — чи вдасться друзям вижити й розкрити таємницю?",
        ageRating: 7,
        languages: [LANGUAGES.UKR],
        author: "Нік Еліопулос",
        year: 2020,
        files: [
          BookFile(title: "Передмова", url: "/minecraft/deep_dive/pre.mp3"),
          BookFile(title: "Розділ 1", url: "/minecraft/deep_dive/01.mp3"),
        ]),
    Book(
      id: 3,
      title: "Minecraft. Цифрова загроза",
      author: "Нік Еліопулос",
      year: 2020,
      imageUrl: "assets/minecraft/cifrova_zagroza/cover.png",
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
      files: [
        BookFile(title: "Передмова", url: "/minecraft/cifrova_zagroza/pre.mp3"),
        BookFile(title: "Розділ 1", url: "/minecraft/cifrova_zagroza/01.mp3"),
        BookFile(title: "Розділ 2", url: "/minecraft/cifrova_zagroza/02.mp3"),
        BookFile(title: "Розділ 3", url: "/minecraft/cifrova_zagroza/03.mp3"),
      ],
    ),
  ];
}

enum LANGUAGES { UKR, RUS }
