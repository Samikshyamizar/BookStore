import 'package:bookstore/AppTheme.dart';
import 'package:bookstore/MainPage.dart';
import 'package:bookstore/auth/LogIn.dart';
import 'package:bookstore/auth/Register.dart';
import 'package:bookstore/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:bookstore/bookstore.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Electronic Shop ',
      theme: AppTheme.lightTheme.copyWith(
        textTheme: GoogleFonts.mulishTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.idTokenChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            if (snapshot.hasData) {
              return MainPage();
            }
            if (snapshot.hasError) {
              return const Text("Some error occured");
            }
            return Bookstore();
          }
        },
      ),
      routes: {
        "/login": (context) => const LogIn(),
        "/register": (context) => const Register(),
        "/home": (context) => MainPage(),
        "/landingPage": (context) => Bookstore(),
      },
    );
  }
}
