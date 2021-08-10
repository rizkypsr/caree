import 'dart:convert';

import 'package:caree/constants.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/http_client.dart';
import 'package:caree/providers/auth.dart';
import 'package:caree/providers/user_provider.dart';

import 'package:caree/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class EmailVerifyScreen extends StatefulWidget {
  const EmailVerifyScreen({Key? key, required this.user}) : super(key: key);

  final User user;

  @override
  _EmailVerifyScreenState createState() => _EmailVerifyScreenState();
}

class _EmailVerifyScreenState extends State<EmailVerifyScreen>
    with WidgetsBindingObserver {
  User? user;
  var _userProvider = UserProvider(DioClient().init());
  var _authProvider = Auth(DioClient().init());

  getUser() async {
    var res = await _userProvider.getUserById(widget.user.id!);

    await UserSecureStorage.setUser(json.encode(res.data.data));

    if (mounted) {
      setState(() {
        user = res.data.data;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
    getUser();
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      print("onresumed");
      getUser();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (user != null) {
      if (user!.isVerified!) {
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil(kHomeRoute, (route) => false);
        });
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Konfirmasi Email",
                  style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.w600),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  "Cek email kamu untuk konfirmasi email. Klik tautan pada email untuk verifikasi akun kamu",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16.0,
                  ),
                ),
                Image.asset("assets/email.png"),
                SizedBox(
                  height: 20.0,
                ),
                Text(
                  "Belum mendapat konfirmasi email?",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 10.0,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: () async {
                        await _authProvider.getVerification(widget.user.email!);
                        EasyLoading.showInfo('Silahkan cek email kamu!');
                      },
                      child: Text('KIRIM ULANG'),
                      style: ElevatedButton.styleFrom(
                          textStyle: TextStyle(fontWeight: FontWeight.bold),
                          primary: kPrimaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0)))),
                )
              ],
            ),
          ),
        ));
  }
}
