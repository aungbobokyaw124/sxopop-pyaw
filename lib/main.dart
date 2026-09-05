import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app_theme.dart';
import 'screens/splash_screen.dart';

Future<void> initializeFirebaseSafely() async {
  try {
    await Firebase.initializeApp().timeout(const Duration(seconds: 8));
    debugPrint('Firebase initialized successfully');
  } catch (e, stackTrace) {
    debugPrint('Firebase initialization failed: $e');
    debugPrintStack(stackTrace: stackTrace);
  }
}

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Start Firebase without blocking Flutter's first frame.
  // Blocking runApp() here can leave Android's native splash screen visible
  // indefinitely when Firebase/network initialization is slow or misconfigured.
  final firebaseFuture = initializeFirebaseSafely();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: AppTheme.background,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(SxopopApp(firebaseReady: firebaseFuture));
}

class SxopopApp extends StatelessWidget {
  const SxopopApp({super.key, required this.firebaseReady});

  final Future<void> firebaseReady;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SXOPOP',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: SplashScreen(firebaseReady: firebaseReady),
    );
  }
}
