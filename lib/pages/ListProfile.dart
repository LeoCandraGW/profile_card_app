import 'package:flutter/material.dart';
import 'package:profile_card/datas/profile.dart';
import 'package:profile_card/datas/skill.dart';
import 'dart:convert';
import 'package:profile_card/static/Navigation.dart';
import 'package:qr_flutter/qr_flutter.dart';

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
      final profileWithoutImage = Map<String, dynamic>.from(profile)
        ..remove('image');
      final merged = {...profileWithoutImage, 'skills': skills};
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
              : ListView.builder(
                  itemCount: data!.length,
                  itemBuilder: (context, index) {
                    final profiles = data![index];
                    final qrItem = (index < qrData.length) ? qrData[index] : {};

                    return Padding(
                      padding: const EdgeInsets.all(10),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            NavigationRoute.DetailPageRoute.name,
                            arguments: profiles['id'] ?? '1',
                          );
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            boxShadow: const [
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                ClipOval(
                                  child: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: _buildProfileImage(
                                      profiles['image'],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  flex: 3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        profiles['name'] ?? '',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(profiles['city'] ?? ''),
                                      Text(profiles['headline'] ?? ''),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          content: SizedBox(
                                            width: 250,
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                const Text(
                                                  'Profile QR Code',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(height: 20),
                                                QrImageView(
                                                  data: jsonEncode(qrItem),
                                                  version: QrVersions.auto,
                                                  size: 200.0,
                                                ),
                                              ],
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              child: const Text('Close'),
                                              onPressed: () =>
                                                  Navigator.of(context).pop(),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: QrImageView(
                                      data: jsonEncode(qrItem),
                                      version: QrVersions.auto,
                                      size: 80.0,
                                      gapless: true,
                                    ),
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

  Widget _buildProfileImage(String? base64Image) {
    try {
      if (base64Image == null || base64Image.isEmpty) {
        return const Icon(Icons.person, size: 50);
      }
      return Image.memory(
        base64Decode(base64Image),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            const Icon(Icons.error, size: 50),
      );
    } catch (e) {
      return const Icon(Icons.error, size: 50);
    }
  }
}
