import 'dart:convert';

import 'package:caree/constants.dart';
import 'package:caree/models/food.dart';
import 'package:caree/models/order.dart';
import 'package:caree/models/single_res.dart';
import 'package:caree/models/user.dart';
import 'package:caree/network/API.dart';
import 'package:caree/utils/map_util.dart';
import 'package:caree/utils/user_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:timeago/timeago.dart' as timeago;

class DetailScreen extends StatefulWidget {
  final Food food;
  const DetailScreen({Key? key, required this.food}) : super(key: key);

  @override
  _DetailScreenState createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final storage = FlutterSecureStorage();
  bool isValidate = false;
  late GoogleMapController mapController;
  final Set<Marker> _markers = {};

  late LatLng _center = LatLng(widget.food.addressPoint!.coordinates[0],
      widget.food.addressPoint!.coordinates[1]);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  _addMarker() {
    setState(() {
      _markers.add(Marker(
          markerId: MarkerId(_center.toString()),
          position: _center,
          infoWindow: InfoWindow(title: 'Tempat Makanan', snippet: ''),
          icon: BitmapDescriptor.defaultMarker));
    });
  }

  _addOrder() async {
    var localUser = await UserSecureStorage.getUser();

    User user = User.fromJson(json.decode(localUser!));

    var order = Order(status: "WAITING", user: user, food: widget.food);

    SingleResponse res = await API.addOrder(order);

    if (res.success) {
      EasyLoading.showSuccess(
          'Berhasil Request. Silahkan menunggu konfirmasi!');

      Navigator.pop(context);
    } else {
      EasyLoading.showError('Terjadi kesalahan!');
    }
  }

  // Check if user already made order
  _checkIfAlreadyMadeOrder() async {
    var localUser = await UserSecureStorage.getUser();
    User user = User.fromJson(json.decode(localUser!));
    var userUuid = user.uuid;
    var foodUserUuid = widget.food.user!.uuid;

    bool isFoodOwner = userUuid == foodUserUuid; // must be false
    bool isAlreadyRequest = widget.food.order!.isNotEmpty; // must be false

    if (!isFoodOwner && !isAlreadyRequest) {
      setState(() {
        isValidate = true;
      });
    }

    // await API.getFoodById(jwt!, uuid!).then((value) {
    //   var order = value!.data.data.order;
    //   bool isFoodOwner = userUuid == foodUserUuid; // must be false
    //   bool isAlreadyRequest = order.isNotEmpty; // must be false

    //   if (!isFoodOwner && !isAlreadyRequest) {
    //     setState(() {
    //       isValidate = true;
    //     });
    //   }
    // });
  }

  @override
  void initState() {
    super.initState();
    _checkIfAlreadyMadeOrder();
    _addMarker();
  }

  @override
  Widget build(BuildContext context) {
    print("Detail AP: ${widget.food.addressPoint}");
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
          widget.food.name,
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(kDefaultPadding),
        child: SizedBox(
          height: 45,
          child: ElevatedButton(
              onPressed: isValidate ? _addOrder : null,
              child: Text("Request Makanan"),
              style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                      isValidate ? kPrimaryColor : Colors.grey),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  )))),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 220,
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        "$BASE_IP/uploads/${widget.food.picture}")),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(kDefaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.food.name,
                    style: TextStyle(
                        color: kSecondaryColor,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: kSecondaryColor.withOpacity(0.5),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        timeago.format(DateTime.parse(widget.food.createdAt!)),
                        style: TextStyle(
                            color: kSecondaryColor.withOpacity(0.5),
                            fontSize: 12.0),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Container(
                        width: 7.0,
                        height: 7.0,
                        decoration: BoxDecoration(
                            color: kSecondaryColor.withOpacity(0.5),
                            shape: BoxShape.circle),
                      ),
                      SizedBox(
                        width: 5.0,
                      ),
                      Text(
                        "4.4 km away",
                        style: TextStyle(
                            color: kSecondaryColor.withOpacity(0.5),
                            fontSize: 12.0),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Wrap(
                    spacing: 10.0,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 12.0,
                        backgroundColor: Colors.white,
                        backgroundImage: widget.food.user!.picture != null
                            ? NetworkImage(
                                "$BASE_IP/uploads/${widget.food.user!.picture}")
                            : AssetImage("assets/people.png") as ImageProvider,
                      ),
                      Text(
                        getFirstWords(widget.food.user!.fullname, 1),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12.0),
                      ),
                      Container(
                        width: 7.0,
                        height: 7.0,
                        decoration: BoxDecoration(
                            color: kSecondaryColor, shape: BoxShape.circle),
                      ),
                      Wrap(
                        spacing: 3.0,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(
                            Icons.star,
                            color: Color(0xFFF7CA63),
                            size: 20,
                          ),
                          Text(
                            widget.food.user!.ratingAvg == null
                                ? "New User"
                                : double.parse(widget.food.user!.ratingAvg!)
                                    .toStringAsFixed(1)
                                    .toString(),
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12.0),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Deskripsi",
                    style: TextStyle(
                        color: kSecondaryColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.food.description,
                    style: TextStyle(color: kSecondaryColor.withOpacity(0.8)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(
                    "Waktu Pengambilan",
                    style: TextStyle(
                        color: kSecondaryColor, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 5.0,
                  ),
                  Text(
                    widget.food.pickupTimes,
                    style: TextStyle(color: kSecondaryColor.withOpacity(0.8)),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Container(
                    width: double.infinity,
                    height: 200,
                    child: GoogleMap(
                        onMapCreated: _onMapCreated,
                        markers: _markers,
                        onTap: (latlng) {
                          MapUtils.openMap(latlng.latitude, latlng.longitude);
                        },
                        initialCameraPosition:
                            CameraPosition(target: _center, zoom: 18)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String getFirstWords(String sentence, int wordCounts) {
  return sentence.split(" ").sublist(0, wordCounts).join(" ");
}
