import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newamariders/general/dashboard.dart';
import 'package:newamariders/general/location_service.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class DeliveryPage extends StatefulWidget {
  double location;
  double location2;
  String orderNo;
  DeliveryPage({super.key, required this.location, required this.location2, required this.orderNo});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState(location, location2, orderNo);
}

class _DeliveryPageState extends State<DeliveryPage> {


   double location;
  double location2;
  String orderNo;
  String Address = 'search';
  final dataseRef = FirebaseDatabase.instance.ref();
  _DeliveryPageState(this.location, this.location2, this.orderNo);

  // Future<Position> _getGeoLocationPosition() async {
  //   bool serviceEnabled;
  //   LocationPermission permission;

  //   // Test if location services are enabled.
  //   serviceEnabled = await Geolocator.isLocationServiceEnabled();
  //   if (!serviceEnabled) {
  //     // Location services are not enabled don't continue
  //     // accessing the position and request users of the
  //     // App to enable the location services.
  //     await Geolocator.openLocationSettings();
  //     return Future.error('Location services are disabled.');
  //   }

  //   permission = await Geolocator.checkPermission();
  //   if (permission == LocationPermission.denied) {
  //     permission = await Geolocator.requestPermission();
  //     if (permission == LocationPermission.denied) {
  //       // Permissions are denied, next time you could try
  //       // requesting permissions again (this is also where
  //       // Android's shouldShowRequestPermissionRationale
  //       // returned true. According to Android guidelines
  //       // your App should show an explanatory UI now.
  //       return Future.error('Location permissions are denied');
  //     }
  //   }

  //   if (permission == LocationPermission.deniedForever) {
  //     // Permissions are denied forever, handle appropriately.
  //     return Future.error(
  //         'Location permissions are permanently denied, we cannot request permissions.');
  //   }

  //   // When we reach here, permissions are granted and we can
  //   // continue accessing the position of the device.
  //   return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  // }

  // Future<void> GetAddressFromLatLong(Position position)async {
  //   List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
  //   print(placemarks);
  //   Placemark place = placemarks[0];
  //   Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
  //   setState(()  {
  //   });
  // }
  // final Completer<GoogleMapController> _controller =
  //     Completer<GoogleMapController>();


  Future<void> completOrder() async{
      try{
        final result = await http.post(Uri.parse("http://api.newamadelivery.co.ke/completeOrder.php"), body: {
          "orderId": orderNo,
          "status": 'Delivered',
          "deliveryTime": DateTime.now()
                                        .millisecondsSinceEpoch
                                        .toString(),


        });
        var response = jsonDecode(result.body);
        if(response["success"] == "true"){
          print("Records Added");
        }
        else{
          print("Something Happened");
        }

      }
      catch(e){
        print(e);
      }
    }

  @override


  
  Widget build(BuildContext context) {
    TextEditingController _searchController = TextEditingController();
  
  // final CameraPosition _kGooglePlex = CameraPosition(
  //   target: LatLng(location, location2),
  //   zoom: 14.4746,
  // );

  //  final Marker _kGooglePlexMarker = Marker(
  //   markerId: MarkerId('_kGooglePlex'),
  //   infoWindow: InfoWindow(title: 'Google Plex'),
  //   icon: BitmapDescriptor.defaultMarker,
  //   position:  LatLng(location, location2),
  // );
  //  CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target:  LatLng(location, location2),
  //     tilt: 59.440717697143555,
  //     zoom: 30);
     return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            
            // SizedBox(
            //   width: double.infinity,
            //   height: 500,
            //   child: Expanded(
            //     child: GoogleMap(
            //       mapType: MapType.normal,
            //       // markers: {_kGooglePlexMarker},
            //       initialCameraPosition: _kGooglePlex,
            //       onMapCreated: (GoogleMapController controller) {
            //         _controller.complete(controller);
            //       },
            //     ),
            //   ),
            // ),
           
            Image.asset('assets/images/map.jpg'),
            Text('GOOGLE MAP IS LOADING...'),
            SizedBox(
              height: 100,
            ),
      
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                
                ElevatedButton(onPressed: (){
                  showDialog(context: context, builder: (context){
                    return AlertDialog(
                      title: Text('Confirm Order Delivery'),
                      content: Text('Do you want to complete order delivery?'),
                      actions: [
                        ElevatedButton(onPressed: (){
                         completOrder();
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>const DashboardPage()));
                        }, 
                        child: Text('Confirm')),
                        ElevatedButton(onPressed: (){
                          Navigator.pop(context);
                        }, 
                        child: Text('Back'))
                      ],
                    );
                  });
                }, child: Text('Complete'))
              ],
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton.extended(
      // onPressed: _goToTheLake,
      // label: const Text('To location!'),
      // icon: const Icon(Icons.directions_boat),
      // ),
    );
  }

  void updateOrder(String status, var deliverTime) {
    dataseRef
        .child('Orders')
        .child('${orderNo}')
        .update({'status': status, 'DeliveryTime': deliverTime});
    dataseRef
        .child('Assignments')
        .child('${orderNo}')
        .update({'status': status, 'DeliveryTime': deliverTime});
  }
   
}