import 'package:flutter/material.dart';
import 'package:profile_card/pages/ListProfile.dart';
import 'package:profile_card/pages/createPage.dart';
import 'package:profile_card/pages/detailPage.dart';
import 'package:profile_card/pages/homePage.dart';
import 'package:profile_card/static/Navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: NavigationRoute.HomePageRoute.name,
      routes: {
        NavigationRoute.HomePageRoute.name: (context) => HomePage(),
        NavigationRoute.CreatePageRoute.name: (context) => CreatePage(),
        NavigationRoute.ListProfileRoute.name: (context) => ListProfile(),
        NavigationRoute.DetailPageRoute.name: (context) {
          final id = ModalRoute.of(context)!.settings.arguments as int;
          return DetailPage(id: id);
        },
      },
    );
  }
}
