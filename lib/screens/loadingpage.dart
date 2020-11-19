import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/textstyles.dart';
import '../constants.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoadingPage extends StatelessWidget {
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool _isInitialized = false;

  Widget _flightShuttleBuilder(
    BuildContext flightContext,
    Animation<double> animation,
    HeroFlightDirection flightDirection,
    BuildContext fromHeroContext,
    BuildContext toHeroContext,
  ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  Future<void> initializeSharedPrefs(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.getInt('fontSize') == null) prefs.setInt('fontSize', 1);
    fontSize = FontSize.values[prefs.getInt('fontSize')];
    if (auth.currentUser != null)
      Navigator.pushReplacementNamed(context, '/home');
    else
      Navigator.pushReplacementNamed(context, '/login');
    _isInitialized = true;
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized) initializeSharedPrefs(context);
    return Scaffold(
      backgroundColor: putih,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'noted',
              flightShuttleBuilder: _flightShuttleBuilder,
              child: Text(
                'noted.',
                style: headerStyle.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
