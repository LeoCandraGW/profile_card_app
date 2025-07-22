import 'package:flutter/material.dart';
import 'package:profile_card/datas/profile.dart';
import 'package:profile_card/datas/rating.dart';
import 'package:profile_card/datas/skill.dart';
import 'package:profile_card/pages/components/ProfileContainer.dart';

class ListProfile extends StatefulWidget {
  const ListProfile({super.key});

  @override
  State<ListProfile> createState() => _ListProfileState();
}

class _ListProfileState extends State<ListProfile> {
  List<Map<String, dynamic>>? data;
  List<Map<String, dynamic>> qrData = [];

  @override
  void initState() {
    super.initState();
    _loadList();
  }

  Future<void> _loadList() async {
    final result = await Profile.instance.listProfile();
    List<Map<String, dynamic>> combinedData = [];

    for (var profile in result) {
      final skills = await Skill.instance.listSkill(profile['id']);
      final rating = await Rating.instance.rating(profile['id']);
      final profileWithoutImage = Map<String, dynamic>.from(profile)
        ..remove('image');
      final merged = {
        ...profileWithoutImage,
        'skills': skills,
        'ratings': rating,
      };
      combinedData.add(merged);
    }

    setState(() {
      data = result;
      qrData = combinedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text('List Profile'))),
      body: Stack(
        children: [
          Container(color: const Color(0xff00b894)),
          (data == null || data!.isEmpty)
              ? const Center(child: Text('No Profile Found'))
              : RefreshIndicator(
                  onRefresh: () async {
                    await _loadList();
                  },
                  child: ListView.builder(
                    itemCount: data!.length,
                    itemBuilder: (context, index) {
                      final profiles = data![index];
                      final qrItem = (index < qrData.length)
                          ? qrData[index]
                          : {};

                      return ProfileContainer(
                        profiles: profiles,
                        qrItem: qrItem,
                        rating: qrItem?['ratings'] ?? 0.0,
                        onSubmit: (submited) async {
                          await _loadList();
                        },
                      );
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
