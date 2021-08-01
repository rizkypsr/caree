import 'package:caree/constants.dart';
import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/models/user.dart';
import 'package:caree/providers/auth.dart';
import 'package:caree/view/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  _showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = ElevatedButton(
        child: Text(
          "Batal",
          style: TextStyle(color: Colors.grey),
        ),
        onPressed: () {
          Navigator.pop(context);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ));
    Widget continueButton = ElevatedButton(
        child: Text("Logout"),
        onPressed: () async {
          await Auth.logOut();
          Navigator.of(context)
              .pushNamedAndRemoveUntil(kHomeRoute, (route) => false);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        ));
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Logout"),
      content: Text("Apakah Anda yakin ingin logout ?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var user = userController.user.value;
      if (userController.isLoading.value) {
        return LoadingAnimation();
      } else {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          body: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(vertical: kDefaultPadding * 2),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: Row(
                      children: [
                        Container(
                          height: 70,
                          width: 70,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                color: kSecondaryColor.withOpacity(0.3),
                                blurRadius: 20,
                                offset: Offset(0, 10),
                                spreadRadius: 0,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: user.picture != null
                                ? Image.network(
                                    "$BASE_IP/uploads/${user.picture}",
                                    fit: BoxFit.cover,
                                  )
                                : Image.asset(
                                    "assets/profile.png",
                                    scale: 2,
                                  ),
                          ),
                        ),
                        SizedBox(
                          width: 20.0,
                        ),
                        Text(
                          user.fullname,
                          style: TextStyle(
                              fontSize: 18.0, fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                  ),
                  Divider(
                    color: kSecondaryColor.withOpacity(0.2),
                    height: 50,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        menu(
                            "Data Profil",
                            FaIcon(FontAwesomeIcons.solidUser),
                            () => Get.toNamed(kProfileFormRoute,
                                arguments: user)),
                        menu(
                            "Daftar Makanan",
                            FaIcon(FontAwesomeIcons.hamburger),
                            () => Get.toNamed(kFoodListRoute)),
                        menu(
                            "About",
                            FaIcon(FontAwesomeIcons.solidQuestionCircle),
                            () => showAboutDialog(
                                context: context,
                                applicationName: "Caree",
                                applicationVersion: "0.0.1"))
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: kDefaultPadding),
                    child: SizedBox(
                      height: 50,
                      child: ElevatedButton(
                          onPressed: () {
                            _showAlertDialog(context);
                          },
                          child: Text(
                            "Logout",
                            style: TextStyle(color: kPrimaryColor),
                          ),
                          style: ButtonStyle(
                              side: MaterialStateProperty.all<BorderSide>(
                                  BorderSide(color: kPrimaryColor)),
                              elevation: MaterialStateProperty.all<double>(0.0),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              )))),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
    });
  }

  Widget menu(String title, Widget icon, void Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(
          kDefaultPadding,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Wrap(
              spacing: 20.0,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                    height: 50,
                    width: 50,
                    padding: EdgeInsets.all(kDefaultPadding * 0.3),
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: kSecondaryColor.withOpacity(0.1),
                            blurRadius: 20,
                            offset: Offset(0, 10),
                            spreadRadius: 0,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Align(alignment: Alignment.center, child: icon)),
                Text(
                  title,
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
            Align(
                alignment: Alignment.centerRight,
                child: FaIcon(FontAwesomeIcons.chevronRight))
          ],
        ),
      ),
    );
  }
}
