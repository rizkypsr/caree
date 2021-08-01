import 'package:caree/constants.dart';
import 'package:caree/models/order.dart';
import 'package:caree/utils/map_util.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class DetailOrderScreen extends StatefulWidget {
  const DetailOrderScreen({Key? key, required this.order}) : super(key: key);

  final Order order;

  @override
  _DetailOrderScreenState createState() => _DetailOrderScreenState();
}

class _DetailOrderScreenState extends State<DetailOrderScreen> {
  late GoogleMapController mapController;

  final Set<Marker> _markers = {};

  late LatLng _center = LatLng(widget.order.food!.addressPoint!.coordinates[0],
      widget.order.food!.addressPoint!.coordinates[1]);

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

  @override
  void initState() {
    super.initState();
    _addMarker();
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          'Detail Pesanan',
          style: TextStyle(color: kSecondaryColor),
        ),
        backgroundColor: Color(0xFFFAFAFA),
        elevation: 0,
      ),
      body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Status Pesanan"),
              Text(
                widget.order.status,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Tanggal Pesanan"),
              Text("Kamis, 20 Juli 2021 - 8:50 AM",
                  style: TextStyle(fontWeight: FontWeight.w600)),
              SizedBox(
                height: 10.0,
              ),
              Text("Pemilik Makanan"),
              Text(
                widget.order.food!.user!.fullname,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 10.0,
              ),
              Text("Penerima"),
              Text(
                widget.order.user!.fullname,
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              Divider(
                color: kSecondaryColor.withAlpha(100),
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Makanan"),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.network(
                                      "$BASE_IP/uploads/${widget.order.food!.picture}",
                                      fit: BoxFit.cover,
                                    )),
                              ),
                              SizedBox(
                                width: 20.0,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.order.food!.name,
                                    style: TextStyle(
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    widget.order.food!.description,
                                    style: TextStyle(fontSize: 11.0),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 16.0,
              ),
              Divider(
                color: kSecondaryColor.withAlpha(100),
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
          )),
    );
  }
}
