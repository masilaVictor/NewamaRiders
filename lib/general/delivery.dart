import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:newamariders/general/location_service.dart';


class DeliveryPage extends StatefulWidget {
  const DeliveryPage({super.key});

  @override
  State<DeliveryPage> createState() => _DeliveryPageState();
}

class _DeliveryPageState extends State<DeliveryPage> {
  @override
  TextEditingController _searchController = TextEditingController();
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(-1.286389, 36.817223),
    zoom: 14.4746,
  );

  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'Google Plex'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(-1.286389, 36.817223),
  );
  static const CameraPosition _kLake = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(-1.286389, 36.817223),
      tilt: 59.440717697143555,
      zoom: 30);
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text('Location'),
        backgroundColor: Colors.red,
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                  child: TextFormField(
                controller: _searchController,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(hintText: 'Search location'),
                onChanged: (value) {
                  print(value);
                },
              )),
              IconButton(
                onPressed: () {
                  LocationService().getPlace(_searchController.text);
                },
                icon: Icon(Icons.search),
              ),
            ],
          ),
          Expanded(
            child: GoogleMap(
              mapType: MapType.normal,
              // markers: {_kGooglePlexMarker},
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton.extended(
      // onPressed: _goToTheLake,
      // label: const Text('To location!'),
      // icon: const Icon(Icons.directions_boat),
      // ),
    );
  }
   Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}