import 'package:caree/constants.dart';
import 'package:caree/core/controllers/bottom_nav_controller.dart';
import 'package:caree/core/controllers/network_controller.dart';
import 'package:caree/core/controllers/user_controller.dart';
import 'package:caree/core/view/email/email_verify_screen.dart';
import 'package:caree/core/view/home/add_food/add_food_screen.dart';
import 'package:caree/core/view/home/add_food/add_map.dart';
import 'package:caree/core/view/home/controllers/food_controller.dart';
import 'package:caree/core/view/home/controllers/map_controller.dart';
import 'package:caree/core/view/home/details/detail_screen.dart';
import 'package:caree/core/view/login/welcome_screen.dart';
import 'package:caree/core/view/message/chat_screen.dart';
import 'package:caree/core/view/message/controllers/chat_controller.dart';
import 'package:caree/core/view/message/controllers/message_controller.dart';
import 'package:caree/core/view/message/message_screen.dart';
import 'package:caree/core/view/order/controllers/order_controller.dart';
import 'package:caree/core/view/order/detail_order.dart';
import 'package:caree/core/view/order/finish_order_screen.dart';
import 'package:caree/core/view/order/order_screen.dart';
import 'package:caree/core/view/profile/detail_profile.dart';
import 'package:caree/core/view/profile/food_list_screen.dart';
import 'package:caree/core/view/profile/profile_form_screen.dart';
import 'package:caree/core/view/profile/profile_screen.dart';
import 'package:caree/core/view/widgets/loading.dart';
import 'package:caree/models/user.dart';
import 'package:caree/providers/auth.dart';
import 'package:caree/core/view/home/home_screen.dart';
import 'package:caree/utils/my_icon_icons.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:showcaseview/showcaseview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  Get.put(NetworkController());
  Get.put<UserController>(UserController());
  Get.lazyPut<MapController>(() => MapController(), fenix: true);
  Get.lazyPut<FoodController>(() => FoodController());
  Get.lazyPut<OrderController>(() => OrderController(), fenix: true);
  Get.lazyPut<MessageController>(() => MessageController(), fenix: true);
  Get.lazyPut<ChatController>(() => ChatController(), fenix: true);

  runApp(GetMaterialApp(
    theme: ThemeData(fontFamily: 'Poppins'),
    home: MyApp(),
    builder: EasyLoading.init(),
    getPages: [
      GetPage(name: kMessageRoute, page: () => MessageScreen()),
      GetPage(name: kWelcomeRoute, page: () => WelcomeScreen()),
      GetPage(name: kOrderRoute, page: () => OrderScreen()),
      GetPage(name: kDetailOrder, page: () => DetailOrderScreen()),
      GetPage(name: kProfileRoute, page: () => ProfileScreen()),
      GetPage(name: kDetailProfile, page: () => DetailProfileScreen()),
      GetPage(name: kAddFood, page: () => AddFoodScreen()),
      GetPage(name: kMapRoute, page: () => AddMapScreen()),
      GetPage(name: kFoodListRoute, page: () => FoodListScreen()),
      GetPage(name: kDetailFood, page: () => DetailScreen()),
      GetPage(name: kProfileFormRoute, page: () => ProfileFormScreen()),
      GetPage(name: kFinishOrderRoute, page: () => FinishOrderScreen()),
      GetPage(name: kChatPrivateRoute, page: () => ChatScreen()),
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

    FirebaseMessaging.instance.subscribeToTopic('food');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Auth.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasData) {
            return ShowCaseWidget(
              builder: Builder(builder: (context) => Main()),
            );
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

class KeysToBeIherited extends InheritedWidget {
  final GlobalKey? menuOrder;
  final GlobalKey? addFoodKey;
  final GlobalKey? myFoodKey;
  final GlobalKey? myOrderFood;
  final GlobalKey? declineFood;
  final GlobalKey? acceptFood;
  final GlobalKey? cancelFood;
  final GlobalKey? finishFood;

  KeysToBeIherited(
      {this.menuOrder,
      this.addFoodKey,
      this.myFoodKey,
      this.myOrderFood,
      this.declineFood,
      this.acceptFood,
      this.cancelFood,
      this.finishFood,
      required Widget child})
      : super(child: child);

  static KeysToBeIherited? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType(aspect: KeysToBeIherited);
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class Main extends StatelessWidget {
  final logger = Logger();
  final BottomNavController _navController = Get.put(BottomNavController());
  final GlobalKey menuOrder = new GlobalKey();
  final GlobalKey addFoodKey = new GlobalKey();
  final GlobalKey myFoodKey = new GlobalKey();
  final GlobalKey myOrderFood = new GlobalKey();
  final GlobalKey declineFood = new GlobalKey();
  final GlobalKey acceptFood = new GlobalKey();
  final GlobalKey cancelFood = new GlobalKey();
  final GlobalKey finishFood = new GlobalKey();

  @override
  Widget build(BuildContext context) {
    SharedPreferences preferences;

    displayShowcase() async {
      preferences = await SharedPreferences.getInstance();
      bool? showcaseVisibilityStatus = preferences.getBool("displayShowcase");

      if (showcaseVisibilityStatus == null) {
        preferences.setBool("displayShowcase", false);
        return true;
      }

      return false;
    }

    displayShowcase().then((status) {
      if (status) {
        ShowCaseWidget.of(context)!.startShowCase([
          addFoodKey,
          menuOrder,
          myFoodKey,
          myOrderFood,
          declineFood,
          acceptFood,
          cancelFood,
          finishFood
        ]);
      }
    });

    return FutureBuilder(
        future: Auth.getAuth(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              var user = snapshot.data as User;
              if (user.isVerified!) {
                return Scaffold(
                    body: Obx(() {
                      List<Widget> _pages = [
                        KeysToBeIherited(
                            addFoodKey: addFoodKey, child: HomeScreen()),
                        MessageScreen(),
                        KeysToBeIherited(
                            myFoodKey: myFoodKey,
                            myOrderFood: myOrderFood,
                            declineFood: declineFood,
                            acceptFood: acceptFood,
                            cancelFood: cancelFood,
                            finishFood: finishFood,
                            child: OrderScreen()),
                        ProfileScreen(),
                      ];

                      return _pages.elementAt(_navController.tabIndex.value);
                    }),
                    bottomNavigationBar: Obx(() => BottomNavigationBar(
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
                                icon: Showcase(
                                    key: menuOrder,
                                    description:
                                        "Klik disini untuk melihat pemesanan",
                                    child: FaIcon(FontAwesomeIcons.utensils)),
                                label: 'Pemesanan'),
                            BottomNavigationBarItem(
                                icon: FaIcon(FontAwesomeIcons.solidUser),
                                label: 'Profil'),
                          ],
                          onTap: _navController.changeTabIndex,
                          currentIndex: _navController.tabIndex.value,
                        )));
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
