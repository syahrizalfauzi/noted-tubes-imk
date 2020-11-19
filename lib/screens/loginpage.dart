import 'package:flutter/material.dart';
import 'package:noted/constants.dart';
import '../models/textstyles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn = GoogleSignIn();
  CollectionReference _collectionReference = FirebaseFirestore.instance.collection('users');

  bool _isSigningIn = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: putih,
      key: _scaffoldKey,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'noted',
              child: Text(
                'noted.',
                style: headerStyle.copyWith(fontWeight: FontWeight.w800),
              ),
            ),
            SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: hitam,
                borderRadius: BorderRadius.circular(5),
                boxShadow: [BoxShadow(blurRadius: 10, color: hitam.withOpacity(0.2), offset: Offset(0, 2))],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: _isSigningIn ? null : _signInWithGoogle,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    child: _isSigningIn
                        ? CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(putih),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset('assets/google_white.png', width: 24, height: 24),
                              SizedBox(width: 12),
                              Text('Login with Google', style: textStyle.copyWith(color: putih)),
                            ],
                          ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> _signInWithGoogle() async {
    _isSigningIn = true;
    GoogleSignInAccount googleSignInAccount = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;
    AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );
    try {
      UserCredential userCredential = await _auth.signInWithCredential(credential);
      await _collectionReference.doc(userCredential.user.uid).set({});
      Navigator.pushReplacementNamed(context, '/home');
    } catch (e) {
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Text(
          'Login failed, please try again',
          style: textStyle.copyWith(color: putih),
        ),
      ));
    }
    _isSigningIn = false;
  }
}
