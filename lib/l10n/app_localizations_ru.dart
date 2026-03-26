// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Новости';

  @override
  String get allNewsTooltip => 'Все новости';

  @override
  String get favoritesTooltip => 'Избранное';

  @override
  String get allTabLabel => 'Все';

  @override
  String get favoritesTabLabel => 'Избранное';

  @override
  String get noNews => 'Нет новостей';

  @override
  String get noFavoritesYet => 'Пока нет избранных новостей';

  @override
  String get backButton => 'Назад';

  @override
  String get newsNotFound => 'Новость не найдена';

  @override
  String get categoryBusiness => 'Бизнес';

  @override
  String get categoryEntertainment => 'Развлечения';

  @override
  String get categoryGeneral => 'Общее';

  @override
  String get categoryHealth => 'Здоровье';

  @override
  String get categoryScience => 'Наука';

  @override
  String get categorySports => 'Спорт';

  @override
  String get categoryTechnology => 'Технологии';

  @override
  String newsAuthor(String author) {
    return 'Автор: $author';
  }
}
