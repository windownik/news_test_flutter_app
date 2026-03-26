import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/network_client.dart';
import 'data/datasources/local/news_local_datasource.dart';
import 'data/datasources/remote/news_remote_datasource.dart';
import 'data/repositories_impl/news_repository_impl.dart';
import 'data/services/image_export_service_impl.dart';
import 'domain/repositories_interfaces/i_news_repository.dart';
import 'domain/services/i_image_export_port.dart';
import 'presentation/screens/news/news_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  final box = await Hive.openBox<String>(NewsLocalDataSource.boxName);

  final networkClient = NetworkClient();
  final remote = NewsRemoteDataSource(networkClient.dio);
  final local = NewsLocalDataSource(box);
  final INewsRepository repository = NewsRepositoryImpl(
    remote: remote,
    local: local,
  );
  final IImageExportPort imageExport = ImageExportServiceImpl();

  runApp(
    NewsApp(
      newsRepository: repository,
      imageExport: imageExport,
    ),
  );
}

class NewsApp extends StatelessWidget {
  const NewsApp({
    super.key,
    required this.newsRepository,
    required this.imageExport,
  });

  final INewsRepository newsRepository;
  final IImageExportPort imageExport;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: NewsScreen(
        newsRepository: newsRepository,
        imageExport: imageExport,
      ),
    );
  }
}
