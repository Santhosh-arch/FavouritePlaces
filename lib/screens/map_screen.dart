import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:san_favourite_places/models/place.dart';
import 'package:san_favourite_places/models/place_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {required this.isSelection,
      this.place = const PlaceLocation(lattitude: 12.9157, longitude: 79.1258, address: ""),
      super.key});
  final PlaceLocation place;
  final bool isSelection;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelection ? "Pick Your Location" : "Your Location"),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          zoom: 14,
          target: LatLng(
            widget.place.lattitude,
            widget.place.longitude,
          ),
        ),
        markers: {
          Marker(
            markerId: MarkerId("m1"),
            position: LatLng(
              widget.place.lattitude,
              widget.place.longitude,
            ),
          )
        },
      ),
    );
  }
}
