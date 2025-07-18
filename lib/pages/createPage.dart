import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:profile_card/datas/profile.dart';
import 'package:profile_card/datas/skill.dart';
import 'package:profile_card/pages/components/customInput.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';
import 'package:profile_card/static/Navigation.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({super.key});

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _name = TextEditingController();
  final TextEditingController _city = TextEditingController();
  final TextEditingController _headline = TextEditingController();
  String? _base64Image;
  Uint8List? _imageBytes;
  final List<TextEditingController> _skillControllers = [];
  bool isSubmit = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera, // You can change to ImageSource.gallery
    );

    if (pickedFile != null) {
      final bytes = await File(pickedFile.path).readAsBytes();
      setState(() {
        _imageBytes = bytes;
        _base64Image = base64Encode(bytes);
      });
    }
  }

  Future _onSubmit() async {
    setState(() {
      isSubmit = true;
    });
    if (_base64Image == null ||
        _base64Image!.isEmpty ||
        _name.text.isEmpty ||
        _city.text.isEmpty ||
        _headline.text.isEmpty) {
      Alert(
        context: context,
        title: "Make sure to enter all data correctly",
        type: AlertType.error,
        buttons: [
          DialogButton(
            onPressed: () {
              Navigator.of(
                context,
                rootNavigator: true,
              ).pop();
            },
            color: Color(0xff74b9ff),
            radius: BorderRadius.circular(10),
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ],
      ).show();
      setState(() {
        isSubmit = false;
      });
      return;
    }
    await Profile.instance.createProfile(
      _base64Image.toString(),
      _name.text,
      _city.text,
      _headline.text,
    );
    final profile_id = await Profile.instance.newProfile();
    for (final controller in _skillControllers) {
      final skillText = controller.text.trim();
      if (skillText.isNotEmpty) {
        await Skill.instance.createSkill(profile_id, skillText);
      }
    }
    Navigator.pushNamed(context, NavigationRoute.ListProfileRoute.name);
  }

  void _addSkillField() {
    setState(() {
      _skillControllers.add(TextEditingController());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Create Profile'))),
      body: Stack(
        children: [
          Container(decoration: BoxDecoration(color: Color(0xfffdcb6e))),
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      _pickImage();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color(0xff74b9ff),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff0984e3),
                            spreadRadius: 4,
                            blurRadius: 0,
                            offset: Offset(-2, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(FontAwesomeIcons.upload),
                            Padding(padding: const EdgeInsets.all(10)),
                            Text('Upload Image'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: (_imageBytes != null)
                      ? Center(
                          child: ClipOval(
                            child: Image.memory(
                              _imageBytes!,
                              width: 150,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : SizedBox.shrink(),
                ),
                CustomInput(
                  hint: 'Name',
                  controller: _name,
                  borderColor: Color(0xff81ecec),
                ),
                CustomInput(
                  hint: 'City',
                  controller: _city,
                  borderColor: Color(0xff81ecec),
                ),
                CustomInput(
                  hint: 'Headline',
                  controller: _headline,
                  borderColor: Color(0xff81ecec),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      ..._skillControllers.map(
                        (controller) => Container(
                          width: 80,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff55efc4),
                                spreadRadius: 4,
                              ),
                            ],
                          ),
                          child: TextField(
                            controller: controller,
                            style: const TextStyle(fontSize: 16),
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              border: InputBorder.none,
                              hintText: 'skill',
                              hintStyle: TextStyle(
                                fontFamily: 'Swansea',
                                letterSpacing: 1.0,
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),

                      // Add Skill Button
                      GestureDetector(
                        onTap: _addSkillField,
                        child: Container(
                          width: 100,
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Color(0xff55efc4),
                                spreadRadius: 4,
                                blurRadius: 0,
                                offset: Offset(-2, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(FontAwesomeIcons.plus, size: 16),
                              SizedBox(width: 5),
                              Text('Skill'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10),
                  child: GestureDetector(
                    onTap: () {
                      isSubmit ? '' : _onSubmit();
                    },
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: isSubmit ? Colors.grey : Color(0xff74b9ff),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xff0984e3),
                            spreadRadius: 4,
                            blurRadius: 0,
                            offset: Offset(-2, 2),
                          ),
                        ],
                      ),
                      child: Center(child: Text('Submit')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
