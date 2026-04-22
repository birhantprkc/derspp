import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';
import 'package:pdfrx/pdfrx.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:dynamic_color/dynamic_color.dart';

import 'providers/theme_provider.dart';
import 'providers/task_provider.dart';
import 'providers/book_provider.dart';
import 'providers/source_provider.dart';
import 'providers/saved_questions_provider.dart';
import 'providers/transcription_provider.dart';
import 'providers/subject_review_provider.dart';
import 'database/database.dart';
import 'ui/navi_bar.dart';

import 'services/cors_proxy_service.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('tr_TR', null);

  if (!kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux ||
          defaultTargetPlatform == TargetPlatform.macOS)) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      minimumSize: Size(160, 250),
      center: true,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.normal,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
  }

  pdfrxFlutterInitialize();
  MediaKit.ensureInitialized();

  final database = AppDatabase();
  await CorsProxyService.instance.init(database);

  runApp(
    MultiProvider(
      providers: [
        Provider<AppDatabase>.value(value: database),
        ChangeNotifierProvider(create: (context) => ThemeProvider(database)),
        ChangeNotifierProvider(create: (context) => TaskProvider(database)),
        ChangeNotifierProvider(create: (context) => BookProvider(database)),
        ChangeNotifierProvider(create: (context) => SourceProvider(database)),
        ChangeNotifierProvider(
          create: (context) => SavedQuestionsProvider(database),
        ),
        ChangeNotifierProvider(create: (context) => TranscriptionProvider()),
        ChangeNotifierProvider(
          create: (context) => SubjectReviewProvider(database),
        ),
      ],
      child: const MainApp(),
    ),
  );
}

class MyScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
    PointerDeviceKind.trackpad,
  };
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        return MaterialApp(
          scrollBehavior: MyScrollBehavior(),
          title: 'derspp',
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.themeMode,
          theme: themeProvider.buildTheme(Brightness.light, lightDynamic),
          darkTheme: themeProvider.buildTheme(Brightness.dark, darkDynamic),
          home: const NaviBar(),
        );
      },
    );
  }
}
