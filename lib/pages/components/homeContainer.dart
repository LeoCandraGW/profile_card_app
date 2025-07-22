import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:profile_card/datas/profile.dart';
import 'package:profile_card/datas/rating.dart';
import 'package:profile_card/datas/skill.dart';
import 'package:profile_card/static/base64image.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class HomeContainer extends StatelessWidget {
  final Color conColor;
  final Color shadColor;
  final String headline;
  final double size;
  final IconData icon;
  final String navigate;
  final bool isDetail;
  final bool isBarcode;

  const HomeContainer({
    super.key,
    required this.conColor,
    required this.shadColor,
    required this.headline,
    required this.size,
    required this.icon,
    required this.navigate,
    required this.isDetail,
    this.isBarcode = false,
  });

  Future<void> _handleTap(BuildContext context) async {
    if (isDetail) {
      if (isBarcode) {
        final result = await SimpleBarcodeScanner.scanBarcode(
          context,
          barcodeAppBar: const BarcodeAppBar(
            appBarTitle: 'Test',
            centerTitle: false,
            enableBackButton: true,
            backButtonIcon: Icon(Icons.arrow_back_ios),
          ),
          isShowFlashIcon: true,
          delayMillis: 500,
          cameraFace: CameraFace.back,
          scanFormat: ScanFormat.ALL_FORMATS,
        );

        if (result != null && result != '-1') {
          try {
            final decoded = jsonDecode(result);
            await Profile.instance.createProfile(
              defaultBase64Image,
              decoded['name'],
              decoded['city'],
              decoded['headline'],
            );
            final profileId = await Profile.instance.newProfile();

            for (var skill in decoded['skills']) {
              await Skill.instance.createSkill(profileId, skill['name']);
            }

            await Rating.instance.insertRating(profileId, decoded['ratings']);

            Navigator.pushNamed(context, navigate, arguments: profileId);
          } catch (e) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Invalid QR data')));
          }
        }
      } else {
        Navigator.pushNamed(context, navigate, arguments: 1);
      }
    } else {
      Navigator.pushNamed(context, navigate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: conColor,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: shadColor,
                spreadRadius: 4,
                blurRadius: 0,
                offset: Offset(-2, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [Icon(icon), Text(headline)],
            ),
          ),
        ),
      ),
    );
  }
}
