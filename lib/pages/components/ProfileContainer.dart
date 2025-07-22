import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profile_card/datas/rating.dart';
import 'package:profile_card/static/Navigation.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:convert';

class ProfileContainer extends StatefulWidget {
  final Map<String, dynamic> profiles;
  final Map<dynamic, dynamic> qrItem;
  final double rating;
  final ValueChanged<bool> onSubmit;
  const ProfileContainer({
    super.key,
    required this.profiles,
    required this.qrItem,
    required this.rating,
    required this.onSubmit,
  });

  @override
  State<ProfileContainer> createState() => _ProfileContainerState();
}

class _ProfileContainerState extends State<ProfileContainer> {
  bool isRating = true;
  double rating = 0.0;

  @override
  void initState() {
    super.initState();
    rating = widget.rating;
  }

  Future _onSubmit(double rating) async {
    await Rating.instance.insertRating(widget.profiles['id'] ?? 0, rating);
    final bool submited = true;
    widget.onSubmit(submited);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GestureDetector(
        onTap: () {
          Navigator.pushNamed(
            context,
            NavigationRoute.DetailPageRoute.name,
            arguments: widget.profiles['id'] ?? '1',
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
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
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: SizedBox(
                        width: 60,
                        height: 60,
                        child: _buildProfileImage(widget.profiles['image']),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.profiles['name'] ?? '',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(widget.profiles['city'] ?? ''),
                          Text(widget.profiles['headline'] ?? ''),
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
                                width: 300,
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
                                      data: jsonEncode(widget.qrItem),
                                      version: QrVersions.auto,
                                      size: 300.0,
                                    ),
                                  ],
                                ),
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () => Navigator.of(context).pop(),
                                ),
                              ],
                            ),
                          );
                        },
                        child: QrImageView(
                          data: jsonEncode(widget.qrItem),
                          version: QrVersions.auto,
                          size: 80.0,
                          gapless: true,
                        ),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        double tempRating = rating;

                        return AlertDialog(
                          backgroundColor: const Color(0xffa29bfe),
                          content: StatefulBuilder(
                            builder: (context, setStateDialog) {
                              final fullStars = tempRating.floor();
                              final hasHalfStar =
                                  (tempRating - fullStars) >= 0.5;

                              return SizedBox(
                                width: 250,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      'Rate this profile',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: List.generate(5, (index) {
                                        IconData icon;
                                        Color color;

                                        if (index < fullStars) {
                                          icon = FontAwesomeIcons.solidStar;
                                          color = const Color(0xfffdcb6e);
                                        } else if (index == fullStars &&
                                            hasHalfStar) {
                                          icon =
                                              FontAwesomeIcons.starHalfStroke;
                                          color = const Color(0xffffeaa7);
                                        } else {
                                          icon = FontAwesomeIcons.star;
                                          color = const Color(0xff2d3436);
                                        }

                                        return GestureDetector(
                                          onTap: () {
                                            setStateDialog(() {
                                              tempRating = index + 1.0;
                                            });
                                          },
                                          child: Icon(
                                            icon,
                                            size: 26,
                                            color: color,
                                          ),
                                        );
                                      }),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  rating = tempRating;
                                  isRating = true;
                                });
                                _onSubmit(tempRating);
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: const Color(0xff74b9ff),
                                  borderRadius: BorderRadius.circular(5),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Color(0xff0984e3),
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                                padding: const EdgeInsets.all(6),
                                child: const Center(
                                  child: Text(
                                    'Submit',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Color(0xffa29bfe),
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xff6c5ce7),
                          spreadRadius: 2,
                          blurRadius: 0,
                          offset: Offset(-1, 1),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(3),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(5, (index) {
                          final fullStars = widget.rating.floor();
                          final hasHalfStar =
                              (widget.rating - fullStars) >= 0.5;

                          if (isRating) {
                            if (index < fullStars) {
                              return Icon(
                                FontAwesomeIcons.solidStar,
                                size: 18,
                                color: Color(0xfffdcb6e),
                              );
                            } else if (index == fullStars && hasHalfStar) {
                              return Icon(
                                FontAwesomeIcons.starHalfStroke,
                                size: 18,
                                color: Color(0xffffeaa7),
                              );
                            } else {
                              return Icon(
                                FontAwesomeIcons.star,
                                size: 18,
                                color: Color(0xffdfe6e9),
                              );
                            }
                          } else {
                            return Icon(
                              FontAwesomeIcons.star,
                              size: 18,
                              color: Color(0xffdfe6e9),
                            );
                          }
                        }),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
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
