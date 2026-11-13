import 'package:material_ui/material_ui.dart';

import 'app/app.dart';

// Основные настройки приложения.
class SeriesGuideApp extends StatelessWidget {
  const SeriesGuideApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Сериал-гид',
      theme: AppTheme.lightTheme,
      routeInformationProvider: router.routeInformationProvider,
      routeInformationParser: router.routeInformationParser,
      routerDelegate: router.routerDelegate,
    );
  }
}
