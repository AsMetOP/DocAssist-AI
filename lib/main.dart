import 'package:doc_assist/provider/result_provider.dart';
import 'package:doc_assist/provider/settings_provider.dart';
import 'package:doc_assist/screens/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:doc_assist/core/theme.dart';
import 'provider/document_provider.dart';
import 'screens/main_navigation.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Supabase
  await Supabase.initialize(
    url: 'https://aywxozucnynuqxjqvybh.supabase.co',
    anonKey: 'sb_publishable_m163a-zIYLkTXEpxC_gMyg_zfSpzOfu',
  );

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(const DoccyApp());
}

class DoccyApp extends StatelessWidget {
  const DoccyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => DocumentProvider()),
        ChangeNotifierProvider(create: (_) => ResultProvider()),
        ChangeNotifierProvider(create: (_) => SettingsProvider()), // ADD THIS
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Doccy',
        theme: AppTheme.lightTheme,
        home: Supabase.instance.client.auth.currentSession == null
            ? const LoginScreen()
            : const MainNavigation(),
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.0),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}