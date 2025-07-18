import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profile_card/pages/components/homeContainer.dart';
import 'package:profile_card/static/Navigation.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(color: Color(0xffe17055))),
          Padding(
            padding: const EdgeInsets.all(10),
            child: LayoutBuilder(
              builder: (context, constraints) {
                return RefreshIndicator(
                  onRefresh: _refresh,
                  child: SingleChildScrollView(
                    physics: AlwaysScrollableScrollPhysics(),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HomeContainer(
                                conColor: Color(0xff00cec9),
                                shadColor: Color(0xff81ecec),
                                headline: 'New Profile',
                                size: 100,
                                icon: FontAwesomeIcons.plus,
                                navigate: NavigationRoute.CreatePageRoute.name,
                                isDetail: false,
                              ),
                              HomeContainer(
                                conColor: Color(0xff00cec9),
                                shadColor: Color(0xff81ecec),
                                headline: 'List Profile',
                                size: 100,
                                icon: FontAwesomeIcons.list,
                                navigate: NavigationRoute.ListProfileRoute.name,
                                isDetail: false,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              HomeContainer(
                                conColor: Color(0xff00cec9),
                                shadColor: Color(0xff81ecec),
                                headline: 'My Profile',
                                size: 100,
                                icon: FontAwesomeIcons.person,
                                navigate: NavigationRoute.DetailPageRoute.name,
                                isDetail: true,
                              ),
                              HomeContainer(
                                conColor: Color(0xff00cec9),
                                shadColor: Color(0xff81ecec),
                                headline: 'Scan Profile',
                                size: 100,
                                icon: FontAwesomeIcons.qrcode,
                                navigate: NavigationRoute.DetailPageRoute.name,
                                isDetail: true,
                                isBarcode: true,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future _refresh() async {}
}
