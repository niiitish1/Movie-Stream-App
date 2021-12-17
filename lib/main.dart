import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_stream_app/home.dart';

main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
    SystemUiOverlay.bottom,
  ]);
  runApp(MaterialApp(
    theme: ThemeData(
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.transparent)),
    debugShowCheckedModeBanner: false,
    home: HomeScreen(),
  ));
}
