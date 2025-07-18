import 'package:flutter/material.dart';
import 'package:profile_card/datas/profile.dart';
import 'dart:convert';

import 'package:profile_card/static/Navigation.dart';

class ListProfile extends StatefulWidget {
  const ListProfile({super.key});

  @override
  State<ListProfile> createState() => _ListProfileState();
}

class _ListProfileState extends State<ListProfile> {
  List<Map<String, dynamic>>? data;
  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    final result = await Profile.instance.listProfile();
    setState(() {
      data = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('List Profile'))),
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(color: Color(0xff00b894))),
          ((data?.length ?? 0) <= 0)
              ? Center(child: Text('No Profile Found'))
              : ListView.builder(
                  itemCount: data?.length,
                  itemBuilder: (context, index) {
                    final profiles = data?[index];
                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NavigationRoute.DetailPageRoute.name,
                            arguments: profiles?['id'] ?? '1',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff74b9ff),
                                spreadRadius: 4,
                                blurRadius: 0,
                                offset: Offset(-2, 2),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                ClipOval(
                                  child: Image.memory(
                                    width: 80,
                                    height: 80,
                                    base64Decode(profiles?['image'] ?? ''),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(profiles?['name'] ?? ''),
                                      Text(profiles?['city'] ?? ''),
                                      Text(profiles?['headline'] ?? ''),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
