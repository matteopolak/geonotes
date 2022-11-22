import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/login/login_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GeoNotes',
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', '')],
      darkTheme: ThemeData(
          useMaterial3: true,
          brightness: Brightness.dark,
          backgroundColor: const Color.fromARGB(255, 18, 18, 18),
          appBarTheme:
              const AppBarTheme(color: Color.fromARGB(255, 12, 12, 12)),
          buttonTheme: const ButtonThemeData(
              buttonColor: Color.fromARGB(255, 150, 235, 226)),
          elevatedButtonTheme: ElevatedButtonThemeData(
              style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 28, 158, 145),
            foregroundColor: Colors.white,
          )),
          floatingActionButtonTheme: const FloatingActionButtonThemeData(
            backgroundColor: Color.fromARGB(255, 28, 158, 145),
          ),
          textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
            foregroundColor: Colors.white,
          )),
          textSelectionTheme: const TextSelectionThemeData(
            cursorColor: Color.fromARGB(255, 28, 158, 145),
          ),
          inputDecorationTheme: const InputDecorationTheme(
              labelStyle: TextStyle(color: Color.fromARGB(255, 150, 150, 150)),
              border: OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 28, 158, 145), width: 2)))),
      themeMode: ThemeMode.dark,
      home: const LoginPage(),
    );
  }
}
