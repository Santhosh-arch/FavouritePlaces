import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:san_favourite_places/models/place.dart';
import 'package:san_favourite_places/models/place_location.dart';

class MapScreen extends StatefulWidget {
  const MapScreen(
      {required this.isSelection,
      this.place = const PlaceLocation(latitude: 12.9157, longitude: 79.1258, address: ""),
      super.key});
  final PlaceLocation place;
  final bool isSelection;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  LatLng? _selectedLatLng;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.isSelection ? "Pick Your Location" : "Your Location"),
        actions: [
          if (widget.isSelection)
            IconButton(
              onPressed: () {
                Navigator.pop(context, _selectedLatLng);
              },
              icon: const Icon(Icons.add),
            )
        ],
      ),
      body: GoogleMap(
        onTap: !widget.isSelection
            ? null
            : (argument) {
                setState(() {
                  _selectedLatLng = argument;
                });
              },
        initialCameraPosition: CameraPosition(
          zoom: 14,
          target: LatLng(
            widget.place.latitude,
            widget.place.longitude,
          ),
        ),
        markers: {
          if (widget.isSelection && _selectedLatLng != null)
            Marker(
              markerId: const MarkerId("m1"),
              position: LatLng(
                _selectedLatLng!.latitude,
                _selectedLatLng!.longitude,
              ),
            )
          else if (!widget.isSelection)
            Marker(
              markerId: const MarkerId("m1"),
              position: LatLng(
                widget.place.latitude,
                widget.place.longitude,
              ),
            )
        },
      ),
    );
  }
}
