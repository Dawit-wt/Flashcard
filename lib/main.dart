import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutterfiretest/app_theme.dart';
import 'package:flutterfiretest/auth_service.dart';
import 'package:flutterfiretest/auth.dart'; // Import Authenticate
import 'package:flutterfiretest/authentication/forgot_password_page.dart';
import 'package:flutterfiretest/home_page.dart';
import 'package:provider/provider.dart';
import 'app_state.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'https://zaqajtigbcsggtvsmqvz.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InphcWFqdGlnYmNzZ2d0dnNtcXZ6Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDU1Njk4MjksImV4cCI6MjA2MTE0NTgyOX0.4ZdkimddK8c6IjcGeoin9TvlWGJhq7Z3jg68wcAcqCI',
  );
  runApp(const MyApp());
}

final supabase = Supabase.instance.client;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
        ChangeNotifierProvider<AppState>(
          create: (_) => AppState(),
        ),
      ],
      child: Builder(builder: (context) {
        return MaterialApp(
          title: 'Flutter FlashCards',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: Provider.of<AppState>(context).isNightModeOn
              ? ThemeMode.dark
              : ThemeMode.light,
          home: AnimatedSplashScreen(
            duration: 1000,
            splash: Image.asset('assets/brain-openmoji.png'),
            splashIconSize: 100,
            nextScreen: const AuthenticationWrapper(),
            splashTransition: SplashTransition.fadeTransition,
            pageTransitionType: PageTransitionType.fade,
            backgroundColor: Colors.white,
          ),
          routes: <String, WidgetBuilder>{
            "/forgotPassword": (BuildContext context) => const ForgotPassword(),
            "/signIn": (BuildContext context) => const Authenticate(),
          },
        );
      }),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = context.watch<User?>();

    if (user == null || user.email == null || user.email!.isEmpty) {
      return const Authenticate(); // Use Authenticate instead of SignInPage
    }

    return HomePage();
  }
}
