// return ListView.builder(
//         itemCount: widget.food.length,
//         itemBuilder: (context, index) {
//           Food food = widget.food[index];

          // double startLatitude = food.addressPoint!.coordinates[0];
          // double startLongitude = food.addressPoint!.coordinates[1];
          // double endLatitude = -0.018609110052682714;
          // double endLongitude = 109.30391574805655;

          // double distanceInMeters = Geolocator.distanceBetween(
          //     startLatitude, startLongitude, endLatitude, endLongitude);

          // String _meterToKilo(double m) {
          //   return (m / 1000).toStringAsFixed(1);
          // }

          // String getFirstWords(String sentence, int wordCounts) {
          //   return sentence.split(" ").sublist(0, wordCounts).join(" ");
          // }

//           return InkWell(
//             onTap: () {
//               Navigator.pushNamed(context, kDetailFood, arguments: food)
//                   .then((_) => setState(() {}));
//             },
//             child: Container(
//               padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 26.0),
//               child: Row(
//                 children: <Widget>[
//                   Stack(
//                     alignment: Alignment.bottomCenter,
//                     clipBehavior: Clip.none,
//                     children: [
//                       Container(
//                         height: 90,
//                         width: 120,
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.all(Radius.circular(20)),
//                           image: DecorationImage(
//                               fit: BoxFit.cover,
//                               image: NetworkImage(
//                                   "$BASE_IP/uploads/${food.picture}")),
//                         ),
//                       ),
//                       Positioned(
//                         bottom: -15,
//                         child: Container(
//                           height: 35,
//                           width: 90,
//                           decoration: BoxDecoration(
//                               color: Colors.white,
//                               borderRadius:
//                                   BorderRadius.all(Radius.circular(20)),
//                               boxShadow: [
//                                 BoxShadow(
//                                   color: Colors.black.withOpacity(0.1),
//                                   blurRadius: 4,
//                                   offset: Offset(0, 1),
//                                   spreadRadius: 0,
//                                 ),
//                               ]),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.center,
//                             children: [
//                               Icon(
//                                 Icons.location_on_rounded,
//                                 color: Color(0xFF292D33),
//                               ),
//                               SizedBox(
//                                 width: 5.0,
//                               ),
//                               Text(
//                                 "${_meterToKilo(distanceInMeters)} km",
//                                 style: TextStyle(fontWeight: FontWeight.bold),
//                               )
//                             ],
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                   SizedBox(
//                     width: 12.0,
//                   ),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: <Widget>[
//                         SizedBox(
//                           width: 240,
//                           child: Text(
//                             food.name,
//                             overflow: TextOverflow.ellipsis,
//                             style: TextStyle(
//                                 color: kSecondaryColor,
//                                 fontSize: 18.0,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                         ),
//                         SizedBox(
//                           height: 5.0,
//                         ),
//                         Text(
//                           food.description,
//                           maxLines: 2,
//                           overflow: TextOverflow.ellipsis,
//                           style: TextStyle(
//                               color: kSecondaryColor,
//                               fontWeight: FontWeight.w300),
//                         ),
//                         Container(
//                           margin: EdgeInsets.symmetric(vertical: 10.0),
//                           child: DottedLine(
//                             lineLength: 240.0,
//                             dashColor: Colors.black.withOpacity(0.2),
//                           ),
//                         ),
//                         Container(
//                           child: Wrap(
//                             spacing: 10.0,
//                             crossAxisAlignment: WrapCrossAlignment.center,
//                             children: [
//                               CircleAvatar(
//                                 radius: 12.0,
//                                 backgroundColor: Colors.white,
//                                 backgroundImage: food.picture != null
//                                     ? NetworkImage(
//                                         "$BASE_IP/uploads/${food.picture}")
//                                     : AssetImage("assets/people.png")
//                                         as ImageProvider,
//                               ),
//                               Text(
//                                 getFirstWords(food.user!.fullname, 1),
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 10.0),
//                               ),
//                               Container(
//                                 width: 7.0,
//                                 height: 7.0,
//                                 decoration: BoxDecoration(
//                                     color: kSecondaryColor,
//                                     shape: BoxShape.circle),
//                               ),
//                               Wrap(
//                                 spacing: 3.0,
//                                 crossAxisAlignment: WrapCrossAlignment.center,
//                                 children: [
//                                   Icon(
//                                     Icons.star,
//                                     color: Color(0xFFF7CA63),
//                                     size: 20,
//                                   ),
//                                   Text(
//                                     food.user!.ratingAvg == null
//                                         ? "User Baru"
//                                         : food.user!.ratingAvg!
//                                             .toStringAsFixed(1),
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold,
//                                         fontSize: 10.0),
//                                   )
//                                 ],
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         });
//   }