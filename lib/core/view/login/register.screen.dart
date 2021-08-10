import 'package:caree/constants.dart';
import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/core/view/login/login_screen.dart';
import 'package:caree/core/view/login/widgets/password_text_field.dart';
import 'package:caree/core/view/login/widgets/rounded_text_field.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/auth.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  UserController userController = Get.find<UserController>();

  var _authProvider = Auth(DioClient().init());

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: _size.height,
          child: Padding(
            padding: const EdgeInsets.only(
                left: kDefaultPadding * 1.5,
                right: kDefaultPadding * 1.5,
                top: kDefaultPadding * 4),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Daftar",
                    style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.w700, height: 0),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Akun",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
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
                PasswordTextField(
                  controller: _passwordController,
                  hintText: "Masukkan password",
                  label: "Password",
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
                        final snackbar = SnackBar(
                          content: Text("Pastikan semua data terisi!"),
                          backgroundColor: Colors.red[400],
                        );

                        String fullname = _nameController.text;
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        bool isNotEmptyField = fullname.isNotEmpty &&
                            email.isNotEmpty &&
                            fullname.isNotEmpty;

                        if (isNotEmptyField) {
                          EasyLoading.show(status: 'loading...');

                          try {
                            SingleResponse? res = await _authProvider
                                .attemptRegister(fullname, email, password);

                            var data = res!.data;

                            await UserSecureStorage.setToken(data.token);
                            await userController.updateLocalUser(data.data);

                            await _authProvider.getVerification(email);

                            EasyLoading.dismiss();

                            Get.offAndToNamed(kHomeRoute);
                          } catch (err) {
                            EasyLoading.dismiss();
                            EasyLoading.showError(err.toString());
                          }
                        } else {
                          EasyLoading.dismiss();
                          ScaffoldMessenger.of(context).showSnackBar(snackbar);
                        }
                      },
                      child: Text('Daftar Sekarang'),
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          primary: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)))),
                ),
                SizedBox(
                  height: 20.0,
                ),
                Wrap(
                  spacing: 3.0,
                  children: [
                    Text("Sudah punya akun?"),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (ctx) => LoginScreen()));
                      },
                      child: Text(
                        "Login",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void displayDialog(BuildContext context, String title, String text) =>
      showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(title: Text(title), content: Text(text)),
      );
}
