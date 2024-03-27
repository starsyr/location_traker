import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:location_traker/provider/auth_provider.dart';
import 'package:location_traker/services/auth/login_or_register.dart';
import 'package:location_traker/view/home_page.dart';

import 'firebase_options.dart';
import 'theme/theme_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // riverpod
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ref.watch(authStateProvider).when(
            data: (user) =>
                user == null ? const LoginOrRegister() : const HomePage(),
            error: (e, s) => const Center(
              child: Text("Error"),
            ),
            loading: () => const Center(
              child: LinearProgressIndicator(),
            ),
          ),
      theme: ref.watch(themeProvider),
    );
  }
}
