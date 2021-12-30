import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_stream_app/home.dart';
import 'package:movie_stream_app/screens/authentication%20screens/google_signin_provider.dart';
import 'package:movie_stream_app/screens/authentication%20screens/login_screen.dart';
import 'package:movie_stream_app/screens/profile_screen.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
  ]);
  runApp(FirstScreen());
}

class FirstScreen extends StatelessWidget {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GoogleSignInProvider(),
      child: MaterialApp(
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch()
                .copyWith(secondary: Colors.transparent)),
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
