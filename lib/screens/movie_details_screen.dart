import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_stream_app/screens/authentication%20screens/login_screen.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({Key? key}) : super(key: key);

  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    var sizes = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: sizes.height * 0.55,
                  child: Image.asset(
                    'assets/trending/t_5.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                const Positioned(
                  top: 40,
                  left: 16,
                  child: RotatedBox(
                      quarterTurns: 2,
                      child: Icon(
                        Icons.arrow_right_alt_outlined,
                        color: Colors.white,
                      )),
                ),
                Positioned(
                  right: 16,
                  bottom: 8,
                  child: Text(
                    '1h 20min',
                    style: TextStyle(
                        color: Colors.white, fontSize: sizes.width * 0.03),
                  ),
                ),
                const Icon(
                  Icons.play_circle,
                  color: Colors.red,
                  size: 40,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
