import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:noted/constants.dart';
import 'package:noted/screens/homepage.dart';
import 'package:noted/screens/loadingpage.dart';
import 'package:noted/screens/loginpage.dart';
import 'package:noted/screens/notepage.dart';
import 'package:noted/screens/settingspage.dart';
import 'package:noted/screens/undefinedpage.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);

    return MaterialApp(
      title: 'Tubes IMK',
      theme: ThemeData(
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        primaryColor: hitam,
        accentColor: hitam,
      ),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return CupertinoPageRoute(builder: (context) => LoadingPage(), settings: settings);
          case '/login':
            return CupertinoPageRoute(builder: (context) => LoginPage(), settings: settings);
          case '/home':
            return CupertinoPageRoute(builder: (context) => HomePage(), settings: settings);
          case '/home/note':
            return CupertinoPageRoute(builder: (context) => NotePage(), settings: settings);
          case '/home/settings':
            return CupertinoPageRoute(builder: (context) => SettingsPage(), settings: settings);
          default:
            return CupertinoPageRoute(builder: (context) => UndefinedPage(), settings: settings);
        }
      },
      initialRoute: '/',
    );
  }
}
