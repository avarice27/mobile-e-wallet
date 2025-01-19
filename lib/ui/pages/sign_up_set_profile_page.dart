import 'dart:convert';
import 'dart:io';

import 'package:bank_sha_rafi/models/sign_up_form_model.dart';
import 'package:bank_sha_rafi/shared/theme.dart';
import 'package:bank_sha_rafi/shared/helpers.dart';
import 'package:bank_sha_rafi/ui/pages/sign_up_set_ktp_page.dart';
import 'package:bank_sha_rafi/ui/widgets/buttons.dart';
import 'package:bank_sha_rafi/ui/widgets/forms.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bank_sha_rafi/ui/pages/home_page.dart';

class SignUpSetProfilePage extends StatefulWidget {
  final SignUpFormModel data;

  const SignUpSetProfilePage({super.key, required this.data});

  @override
  State<SignUpSetProfilePage> createState() => _SignUpSetProfilePageState();
}

class _SignUpSetProfilePageState extends State<SignUpSetProfilePage> {
  final pinController = TextEditingController(text: '');
  XFile? selectedImage;

  // Future<XFile?> selectImage() async {
  //   final imagePicker = ImagePicker();
  //   final XFile? image = await imagePicker.pickImage(
  //     source: ImageSource.gallery,
  //   );

  //   return image;
  // }

  bool validate() {
    if (pinController.text.length != 6) {
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        children: [
          Container(
            width: 155,
            height: 50,
            margin: const EdgeInsets.only(
              top: 100,
              bottom: 100,
            ),
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                  'assets/img_logo_light.png',
                ),
              ),
            ),
          ),
          Text(
            'Join Us to Unlock\nYour Growth',
            style: blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: whiteColor,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    final image = await selectImage();
                    setState(() {
                      selectedImage = image;
                    });
                  },
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: lightBackgroundColor,
                      image: selectedImage == null
                          ? null
                          : DecorationImage(
                              fit: BoxFit.cover,
                              image: FileImage(
                                File(
                                  selectedImage!.path,
                                ),
                              ),
                            ),
                    ),
                    child: selectedImage != null
                        ? null
                        : Center(
                            child: Image.asset(
                              'assets/ic_upload.png',
                              width: 32,
                            ),
                          ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Text(
                  widget.data.name
                      .toString(), // Use the name from the SignUpFormModel
                  style: blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: medium,
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFormField(
                  title: 'Set PIN (6 digit number)',
                  obscureText: true,
                  controller: pinController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 30,
                ),
                CustomFilledButton(
                  title: 'Continue',
                  onPressed: () {
                    if (validate()) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SignUpSetKtpPage(
                            data: widget.data.copyWith(
                                pin: pinController.text,
                                profilePicture: selectedImage == null
                                    ? null
                                    : 'data:image/png;base64,${base64Encode(
                                        File(selectedImage!.path)
                                            .readAsBytesSync(),
                                      )}'),
                          ),
                        ),
                      );
                    } else {
                      showCustomSnackbar(context, 'PIN harus 6 digit.');
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(
            height: 50,
          ),
        ],
      ),
    );
  }
}
