import 'package:flutter/material.dart';
import '../models/textstyles.dart';
import '../constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  SharedPreferences prefs;
  FirebaseAuth _auth = FirebaseAuth.instance;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initPrefs() async {
    prefs = await SharedPreferences.getInstance();
  }

  @override
  void initState() {
    super.initState();
    initPrefs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        toolbarHeight: 80,
        elevation: 0,
        backgroundColor: putih,
        iconTheme: IconThemeData(color: hitam),
        actions: [Center(child: Text('Settings', style: headerStyle)), SizedBox(width: 16)],
      ),
      backgroundColor: putih,
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                _auth.currentUser.photoURL,
                height: 70,
                width: 70,
                fit: BoxFit.fill,
              ),
            ),
            SizedBox(height: 16),
            Text(_auth.currentUser.displayName, textAlign: TextAlign.center, style: textStyle.copyWith(fontWeight: FontWeight.w600)),
            SizedBox(height: 16),
            Text(_auth.currentUser.email, textAlign: TextAlign.center, style: textStyle.copyWith(fontWeight: FontWeight.w300)),
            SizedBox(height: 32),
            settingsButton(
              onPress: () {
                _scaffoldKey.currentState.showSnackBar(SnackBar(
                  content: Text('Premium version is not yet available', style: textStyle.copyWith(color: putih)),
                ));
              },
              child: Align(alignment: Alignment.centerLeft, child: Text('Buy Premium', style: textStyle)),
            ),
            SizedBox(height: 12),
            settingsButton(
              onPress: showFontSizeSettings,
              child: Row(
                children: [
                  Text('Font Size', style: textStyle),
                  Spacer(),
                  Text(fontSizeText, style: textStyle),
                ],
              ),
            ),
            Spacer(),
            MaterialButton(
              onPressed: () async {
                await _auth.signOut();
                Navigator.of(context).pushNamedAndRemoveUntil('/login', ModalRoute.withName('/login'));
              },
              child: Text('Log Out', style: textStyle.copyWith(color: merah)),
            ),
            SizedBox(height: 64),
          ],
        ),
      ),
    );
  }

  MaterialButton settingsButton({void Function() onPress, Widget child}) {
    return MaterialButton(
      onPressed: onPress,
      color: putih,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5), side: BorderSide(color: abu)),
      padding: EdgeInsets.all(12),
      child: child,
      splashColor: abu,
    );
  }

  void showFontSizeSettings() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: putih,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<FontSize>(
                groupValue: fontSize,
                value: FontSize.small,
                onChanged: (value) {
                  setState(() => fontSize = value);
                  prefs.setInt('fontSize', value.index);
                  Navigator.pop(context);
                },
                title: Text('Small', style: textStyle),
              ),
              RadioListTile<FontSize>(
                groupValue: fontSize,
                value: FontSize.medium,
                onChanged: (value) {
                  setState(() => fontSize = value);
                  prefs.setInt('fontSize', value.index);
                  Navigator.pop(context);
                },
                title: Text('Medium', style: textStyle),
              ),
              RadioListTile<FontSize>(
                groupValue: fontSize,
                value: FontSize.large,
                onChanged: (value) {
                  setState(() => fontSize = value);
                  prefs.setInt('fontSize', value.index);
                  Navigator.pop(context);
                },
                title: Text('Large', style: textStyle),
              ),
            ],
          ),
        );
      },
    );
  }
}
