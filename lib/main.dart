import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'features/login/login_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import './features/notes/notes_controller.dart';

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
      theme: ThemeData(
        useMaterial3: true,
        // make the colour of the appbar background darker than the primary
        // colour
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 28, 158, 145),
        ),
        primarySwatch: MaterialColor(
            const Color.fromARGB(255, 28, 158, 145).hashCode, const {
          // use Material 3 colors
          50: Color.fromARGB(255, 238, 255, 254),
          100: Color.fromARGB(255, 238, 255, 254),
          200: Color.fromARGB(255, 238, 255, 254),
          300: Color.fromARGB(255, 238, 255, 254),
          400: Color.fromARGB(255, 51, 255, 232),
          500: Color.fromARGB(255, 0, 255, 226),
          600: Color.fromARGB(255, 0, 229, 201),
          700: Color.fromARGB(255, 0, 204, 176),
          800: Color.fromARGB(255, 0, 178, 151),
          900: Color.fromARGB(255, 0, 153, 127),
        }),
        inputDecorationTheme: const InputDecorationTheme(
          labelStyle: TextStyle(color: Color.fromARGB(255, 150, 150, 150)),
          border: OutlineInputBorder(),
          focusedBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Color.fromARGB(255, 28, 158, 145), width: 2),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 28, 158, 145),
          foregroundColor: Colors.white,
        )),
      ),
      darkTheme: ThemeData(
          useMaterial3: true,
          primarySwatch: // use a dark theme with the primary colours for text
              MaterialColor(
                  const Color.fromARGB(255, 28, 158, 145).hashCode, const {
            // use Material 3 colors
            50: Color.fromARGB(255, 238, 255, 254),
            100: Color.fromARGB(255, 204, 255, 250),
            200: Color.fromARGB(255, 153, 255, 244),
            300: Color.fromARGB(255, 102, 255, 238),
            400: Color.fromARGB(255, 51, 255, 232),
            500: Color.fromARGB(255, 0, 255, 226),
            600: Color.fromARGB(255, 0, 229, 201),
            700: Color.fromARGB(255, 0, 204, 176),
            800: Color.fromARGB(255, 0, 178, 151),
            900: Color.fromARGB(255, 0, 153, 127),
          }),
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
                  color: Color.fromARGB(255, 28, 158, 145), width: 2),
            ),
          ),
          textTheme:
              const TextTheme(subtitle1: TextStyle(color: Colors.white))),
      themeMode: ThemeMode.system,
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const NotesPage(),
    );
  }
}
