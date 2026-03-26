// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'News';

  @override
  String get allNewsTooltip => 'All news';

  @override
  String get favoritesTooltip => 'Favorites';

  @override
  String get allTabLabel => 'All';

  @override
  String get favoritesTabLabel => 'Favorites';

  @override
  String get noNews => 'No news';

  @override
  String get noFavoritesYet => 'No favorites yet';

  @override
  String get backButton => 'Back';

  @override
  String get newsNotFound => 'News not found';

  @override
  String get categoryBusiness => 'Business';

  @override
  String get categoryEntertainment => 'Entertainment';

  @override
  String get categoryGeneral => 'General';

  @override
  String get categoryHealth => 'Health';

  @override
  String get categoryScience => 'Science';

  @override
  String get categorySports => 'Sports';

  @override
  String get categoryTechnology => 'Technology';

  @override
  String newsAuthor(String author) {
    return 'Author: $author';
  }
}
