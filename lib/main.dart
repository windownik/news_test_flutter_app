import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network_client.dart';
import 'data/datasources/local/news_local_datasource.dart';
import 'data/datasources/remote/news_remote_datasource.dart';
import 'data/repositories_impl/news_repository_impl.dart';
import 'domain/repositories_interfaces/i_news_repository.dart';
import 'l10n/app_localizations.dart';
import 'presentation/screens/news/news_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load();
  await Hive.initFlutter();
  final box = await Hive.openBox<String>(NewsLocalDataSource.boxName);

  final networkClient = NetworkClient();
  final remote = NewsRemoteDataSource(
    networkClient.dio,
    apiKey: dotenv.maybeGet('NEWS_API_KEY'),
  );
  final local = NewsLocalDataSource(box);
  final INewsRepository repository = NewsRepositoryImpl(
    remote: remote,
    local: local,
  );

  runApp(NewsApp(newsRepository: repository));
}

class NewsApp extends StatelessWidget {
  const NewsApp({super.key, required this.newsRepository});

  final INewsRepository newsRepository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      debugShowCheckedModeBanner: false,
      supportedLocales: AppLocalizations.supportedLocales,
      home: NewsScreen(newsRepository: newsRepository),
    );
  }
}
