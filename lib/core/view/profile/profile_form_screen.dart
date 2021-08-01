import 'dart:io';
import 'package:caree/constants.dart';
import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:caree/view/login/widgets/phone_text_field.dart';
import 'package:caree/view/login/widgets/rounded_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileFormScreen extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final UserController _userController = Get.find<UserController>();

  _getImageFromGallery() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      _userController.imagePath.value = pickedFile.path;

      Get.back();
    }
  }

  _getImageFromCamera() async {
    PickedFile? pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      _userController.imagePath.value = pickedFile.path;

      Get.back();
    }
  }

  _updateUser(String uuid) async {
    String userFullname = _nameController.text;
    String userEmail = _emailController.text;
    String userPhone = _phoneController.text;

    if (userFullname.isNotEmpty &&
        userEmail.isNotEmpty &&
        userPhone.isNotEmpty) {
      var _user = User(
          uuid: uuid,
          fullname: userFullname,
          email: userEmail,
          phone: userPhone);

      SingleResponse res = await _userController.updateUser(_user);

      if (res.success) {
        await _userController.fetchUser(uuid);
      } else {
        EasyLoading.showError(res.message);
      }
    } else {
      Get.snackbar("Kesalahan", "Pastikan semua field terisi!");
    }

    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    print("logs: rebuild...");
    var user = Get.arguments;

    if (user != null) {
      _nameController.text = user.fullname;
      _emailController.text = user.email;
      _phoneController.text = user.phone;
    }

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: kSecondaryColor,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Profil',
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(
                                left: kDefaultPadding * 0.7,
                                top: kDefaultPadding,
                                bottom: kDefaultPadding * 0.3),
                            child: Text(
                              "Ganti Foto Profil",
                              style: TextStyle(
                                  fontSize: 20,
                                  color: kSecondaryColor,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListTile(
                            leading: new Icon(Icons.camera),
                            title: new Text('Camera'),
                            onTap: () {
                              _getImageFromCamera();
                            },
                          ),
                          ListTile(
                            leading: new Icon(Icons.photo),
                            title: new Text('Gallery'),
                            onTap: () {
                              _getImageFromGallery();
                            },
                          ),
                        ],
                      );
                    });
              },
              child: Container(
                width: 100,
                child: Stack(
                  children: [
                    Obx(() {
                      return CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white,
                        backgroundImage: _userController
                                .imagePath.value.isNotEmpty
                            ? FileImage(File(_userController.imagePath.value))
                            : user.picture != null
                                ? Image.network(
                                        "$BASE_IP/uploads/${user.picture}")
                                    .image
                                : Image.network(
                                    "https://ui-avatars.com/api/?name=${user.fullname}",
                                  ).image,
                      );
                    }),
                    Align(
                        alignment: Alignment.topRight,
                        child: CircleAvatar(
                            backgroundColor: kPrimaryColor,
                            child: FaIcon(
                              FontAwesomeIcons.camera,
                              color: Colors.white,
                              size: 20,
                            ))),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            RoundedTextField(
              controller: _nameController,
              hintText: "Masukkan nama",
              label: "Nama",
              color: kSecondaryColor.withOpacity(0.3),
              backgroundColor: kPrimaryColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 10.0,
            ),
            RoundedTextField(
              controller: _emailController,
              hintText: "Masukkan email",
              label: "Email",
              color: kSecondaryColor.withOpacity(0.3),
              backgroundColor: kPrimaryColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 10.0,
            ),
            SizedBox(
              height: 10.0,
            ),
            PhoneTextField(
              controller: _phoneController,
              label: "Nomor hp",
              hintText: "Masukkan no hp",
              color: kSecondaryColor.withOpacity(0.3),
              backgroundColor: kPrimaryColor.withOpacity(0.2),
            ),
            SizedBox(
              height: 30.0,
            ),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                  onPressed: () async {
                    _updateUser(user.uuid);
                  },
                  child: Text('Ubah Data'),
                  style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(fontWeight: FontWeight.bold),
                      primary: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0)))),
            ),
            SizedBox(
              height: 20.0,
            ),
          ],
        ),
      ),
    );
  }
}
