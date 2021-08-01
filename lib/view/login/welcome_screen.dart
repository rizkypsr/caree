import 'package:caree/constants.dart';
import 'package:caree/view/login/login_screen.dart';
import 'package:caree/view/login/register.screen.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding * 2),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset("assets/welcome.png"),
              Text(
                'Caree',
                style: TextStyle(
                    fontSize: 52.0,
                    color: kPrimaryColor,
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                "Caree adalah aplikasi berbagi makanan gratis. Ya, GRATIS! ",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: kSecondaryColor,
                  fontSize: 16.0,
                ),
              ),
              SizedBox(
                height: 40.0,
              ),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (ctx) => RegisterScreen()));
                    },
                    child: Text("Daftar Akun dengan Email"),
                    style: ButtonStyle(
                        elevation: MaterialStateProperty.all<double>(0),
                        backgroundColor:
                            MaterialStateProperty.all<Color>(kPrimaryColor),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        )))),
              ),
              SizedBox(
                height: 10.0,
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
