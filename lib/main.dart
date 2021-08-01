import 'package:caree/constants.dart';
import 'package:caree/core/controllers/network_controller.dart';
import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/core/view/home/add_food/add_food_screen.dart';
import 'package:caree/core/view/home/add_food/add_map.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/core/view/home/controllers/map_controller.dart';
import 'package:caree/core/view/profile/food_list_screen.dart';
import 'package:caree/core/view/profile/profile_form_screen.dart';
import 'package:caree/core/view/profile/profile_screen.dart';
import 'package:caree/models/user.dart';
import 'package:caree/providers/auth.dart';
import 'package:caree/view/email/email_verify_screen.dart';
import 'package:caree/core/view/home/home_screen.dart';
import 'package:caree/view/login/welcome_screen.dart';
import 'package:caree/view/message/message_screen.dart';
import 'package:caree/view/order/order_screen.dart';
import 'package:caree/utils/my_icon_icons.dart';
import 'package:caree/view/widgets/loading.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(NetworkController());
  Get.put(MapController());
  Get.lazyPut<FoodController>(() => FoodController());
  Get.lazyPut<UserController>(() => UserController());

  runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: 'Poppins'),
    home: MyApp(),
    builder: EasyLoading.init(),
    getPages: [
      GetPage(name: kMessageRoute, page: () => MessageScreen()),
      GetPage(name: kOrderRoute, page: () => OrderScreen()),
      GetPage(name: kProfileRoute, page: () => ProfileScreen()),
      GetPage(name: kAddFood, page: () => AddFoodScreen()),
      GetPage(name: kMapRoute, page: () => AddMapScreen()),
      GetPage(name: kFoodListRoute, page: () => FoodListScreen()),
      GetPage(
        name: kProfileFormRoute,
        page: () => ProfileFormScreen(),
      ),
    ],
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final storage = FlutterSecureStorage();
  var logger = Logger();

  @override
  void initState() {
    super.initState();

    FirebaseMessaging.instance.getInitialMessage();
    FirebaseMessaging.onMessage.listen((event) {
      if (event.notification != null) {
        print(event.notification!.title);
        print(event.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data['route'];
      final dataFromMessage = message.data['data'];

      print(routeFromMessage);
      print(dataFromMessage);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return Main();
          }

          if (snapshot.hasError) {
            logger.e(snapshot.error);
            return Center(
              child: Text("Terjadi kesalahan!. Install ulang aplikasi"),
            );
          }
          return WelcomeScreen();
        }

        return LoadingAnimation();
      },
    );
  }
}

class Main extends StatefulWidget {
  const Main({Key? key}) : super(key: key);

  @override
  _MainState createState() => _MainState();
}

class _MainState extends State<Main> {
  var logger = Logger();
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      HomeScreen(),
      MessageScreen(),
      OrderScreen(),
      ProfileScreen(),
    ];

    return FutureBuilder(
        future: Auth.getAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var user = snapshot.data as User;
              if (user.isVerified!) {
                return Scaffold(
                    body: _widgetOptions.elementAt(_selectedIndex),
                    bottomNavigationBar: BottomNavigationBar(
                      type: BottomNavigationBarType.fixed,
                      backgroundColor: Colors.white,
                      selectedItemColor: kPrimaryColor,
                      unselectedItemColor: Color(0xFF292D33),
                      showSelectedLabels: false,
                      showUnselectedLabels: false,
                      items: [
                        BottomNavigationBarItem(
                            icon: Icon(MyIcon.homeIcon), label: 'Beranda'),
                        BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.solidComment),
                            label: 'Pesan'),
                        BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.utensils),
                            label: 'Pemesanan'),
                        BottomNavigationBarItem(
                            icon: FaIcon(FontAwesomeIcons.solidUser),
                            label: 'Profil'),
                      ],
                      onTap: _onItemTapped,
                      currentIndex: _selectedIndex,
                    ));
              } else {
                return EmailVerifyScreen(
                  user: user,
                );
              }
            }

            if (snapshot.hasError) {
              logger.e(snapshot.error);
              return Center(
                child: Text("Error: ${snapshot.error}"),
              );
            }
          }

          return LoadingAnimation();
        });
  }
}
