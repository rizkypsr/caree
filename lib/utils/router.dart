import 'package:caree/constants.dart';
import 'package:caree/models/chat.dart';
import 'package:caree/models/food.dart';
import 'package:caree/models/order.dart';
import 'package:caree/models/user.dart';
import 'package:caree/view/home/details/detail_screen.dart';
import 'package:caree/view/login/welcome_screen.dart';
import 'package:caree/view/message/chat_screen.dart';
import 'package:caree/view/order/detail_order.dart';
import 'package:caree/view/order/finish_order_screen.dart';
import 'package:flutter/material.dart';

class Routers {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case kChatPrivateRoute:
        var data = settings.arguments as Chat;
        return MaterialPageRoute(
            builder: (_) => ChatScreen(
                  chat: data,
                ));
      case kFinishOrderRoute:
        var data = settings.arguments as User;
        return MaterialPageRoute(
            builder: (_) => FinishOrderScreen(
                  user: data,
                ));
      case kDetailOrder:
        var data = settings.arguments as Order;
        return MaterialPageRoute(
            builder: (_) => DetailOrderScreen(
                  order: data,
                ));
      case kDetailFood:
        var data = settings.arguments as Food;
        return MaterialPageRoute(
            builder: (_) => DetailScreen(
                  food: data,
                ));
      case kWelcomeRoute:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      default:
        return MaterialPageRoute(
            builder: (_) => Scaffold(
                  body: Center(
                    child: Text('No Route defined for ${settings.name}'),
                  ),
                ));
    }
  }
}
