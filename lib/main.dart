import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  Completer<GoogleMapController> _controller = Completer();
  GoogleMapController mapController;
  LatLng _lastMapPosition = _center;

  static const LatLng _center = const LatLng(45.521563, -122.677433);

  final Set<Marker> _markers = {};

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    _controller.complete(controller);

    LatLng latLng_1 = LatLng(40.416775, -3.70379);
    LatLng latLng_2 = LatLng(41.385064, 2.173403);
    LatLngBounds bound = LatLngBounds(southwest: latLng_1, northeast: latLng_2);

    setState(() {
      _markers.clear();
      addMarker(latLng_1, "Madrid", "5 Star Rating");
      addMarker(latLng_2, "Barcelona", "7 Star Rating");
    });

    CameraUpdate u2 = CameraUpdate.newLatLngBounds(bound, 50);
    this.mapController.animateCamera(u2).then((void v){
      check(u2,this.mapController);
    });

  }

  void addMarker(LatLng mLatLng, String mTitle, String mDescription){
    _markers.add(Marker(
      // This marker id can be anything that uniquely identifies each marker.
      markerId: MarkerId((mTitle + "_" + _markers.length.toString()).toString()),
      position: mLatLng,
      infoWindow: InfoWindow(
        title: mTitle,
        snippet: mDescription,
      ),
      icon: BitmapDescriptor.defaultMarker,
    ));
  }

  void check(CameraUpdate u, GoogleMapController c) async {
    c.animateCamera(u);
    mapController.animateCamera(u);
    LatLngBounds l1=await c.getVisibleRegion();
    LatLngBounds l2=await c.getVisibleRegion();
    print(l1.toString());
    print(l2.toString());
    if(l1.southwest.latitude==-90 ||l2.southwest.latitude==-90)
      check(u, c);
  }


  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Maps Sample App'),
          backgroundColor: Colors.green[700],
        ),
        body: GoogleMap(
          markers: _markers,
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
          onCameraMove: _onCameraMove,
        ),
      ),
    );
  }
}