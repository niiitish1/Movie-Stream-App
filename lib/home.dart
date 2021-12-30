import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:movie_stream_app/const/colors.dart';
import 'package:movie_stream_app/const/my_array.dart';
import 'package:movie_stream_app/screens/authentication%20screens/login_screen.dart';
import 'package:movie_stream_app/screens/profile_screen.dart';
import 'package:movie_stream_app/screens/stream_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late final TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: tablist.length, vsync: this);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkBlue,
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(child: Text('something has error'));
            } else if (snapshot.hasData) {
              return Column(
                children: [
                  TabBar(
                    labelPadding: const EdgeInsets.only(left: 10, right: 0),
                    padding: const EdgeInsets.only(left: 0, right: 0, top: 20),
                    labelColor: tabBarSelectedColor,
                    unselectedLabelColor: Colors.white60,
                    controller: _tabController,
                    indicatorColor: Colors.transparent,
                    labelStyle: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                    tabs: List.generate(
                      tablist.length,
                      (index) => Tab(
                        text: tablist[index],
                      ),
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: List.generate(
                        tablist.length,
                        (index) => buildPageViewScreens(index),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return LoginScreen();
            }
          }),
    );
  }

  Widget buildPageViewScreens(int index) {
    if (index == 0) {
      return StreamScreen();
    } else {
      return ProfileScreen();
    }
  }
}
