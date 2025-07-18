import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';
import 'dart:convert';
import 'package:profile_card/datas/profile.dart';
import 'package:profile_card/datas/skill.dart';

class DetailPage extends StatefulWidget {
  final int id;
  const DetailPage({super.key, required this.id});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Map<String, dynamic>? dataProfile;
  List<Map<String, dynamic>>? dataSkill;

  @override
  void initState() {
    super.initState();
    _loadDetail();
  }

  Future _loadDetail() async {
    final result = await Profile.instance.profileCard(widget.id);
    final resultskill = await Skill.instance.listSkill(widget.id);
    setState(() {
      dataProfile = result;
      dataSkill = resultskill;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    if (dataProfile == null) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(color: Color(0xff0984e3))),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.9,
                decoration: BoxDecoration(
                  color: Color(0xff74b9ff),
                  borderRadius: BorderRadius.all(Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                      color: Color(0xffdfe6e9),
                      spreadRadius: 7,
                      blurRadius: 10,
                      offset: Offset(1, 1),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color(0xff0984e3),
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xffdfe6e9),
                              spreadRadius: 3,
                              blurRadius: 0,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(5),
                          child: Center(
                            child: ClipOval(
                              child: Image.memory(
                                base64Decode(dataProfile?['image'] ?? ''),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          SizedBox(
                            height: 30,
                            width: screenWidth * 0.8,
                            child: Marquee(
                              text: dataProfile?['name'] ?? '',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                              scrollAxis: Axis.horizontal,
                              blankSpace: 50.0,
                              velocity: 30.0,
                              pauseAfterRound: Duration(seconds: 1),
                              startPadding: 10.0,
                              accelerationDuration: Duration(seconds: 1),
                              accelerationCurve: Curves.linear,
                              decelerationDuration: Duration(milliseconds: 500),
                              decelerationCurve: Curves.easeOut,
                            ),
                          ),
                          Text(
                            dataProfile?['headline'] ?? '',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            dataProfile?['city'] ?? '',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: double.infinity,
                        height: 100,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff0984e3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: Center(
                          child: Text(
                            'Bio Section (Customize me)',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: Color(0xff0984e3),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(50),
                          ),
                        ),
                        child: ((dataSkill?.length ?? 0) <= 0)
                            ? Text('No skills listed.')
                            : Padding(
                                padding: const EdgeInsets.all(20),
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: [
                                    ...dataSkill!.map(
                                      (skill) => Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 10,
                                        ),
                                        alignment: Alignment.center,
                                        width: 80,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(50),
                                            topRight: Radius.circular(10),
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(50),
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xff55efc4),
                                              spreadRadius: 4,
                                            ),
                                          ],
                                        ),
                                        child: Text(
                                          skill['name'] ?? '',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
