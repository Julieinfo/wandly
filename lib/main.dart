import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:wandly/theme/gryffondor_theme.dart';
import 'package:wandly/services/router.dart';
import 'package:wandly/services/storage_service.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Initialize Hive without blocking main thread
  try {
    await StorageService().init().timeout(
      const Duration(seconds: 5),
      onTimeout: () => print('[TIMEOUT] Hive init took too long'),
    );
  } catch (e) {
    print('[INIT ERROR] Hive: $e');
  }

  FlutterNativeSplash.remove();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp.router(
        title: 'Wandly',
        theme: gryffondorTheme,
        routerConfig: router,
      ),
    );
  }
}
