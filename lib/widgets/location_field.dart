import "dart:convert";

import "package:flutter/material.dart";
import "package:location/location.dart";
import "package:http/http.dart" as http;
import "package:san_favourite_places/config/config.dart";

class LocationField extends StatefulWidget {
  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  Location? selectedLocation;
  bool isLocationLoading = false;

  Future<void> getCurrentLocation() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    setState(() {
      isLocationLoading = true;
    });

    _locationData = await location.getLocation();
    final jsonRes = await http.get(Uri.parse(
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${_locationData.latitude},${_locationData.longitude}&key=${Config.mapApiKey}"));
    final res = jsonDecode(jsonRes.body);
    final address = res["results"][0]["formatted_address"];
    setState(() {
      isLocationLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      "No location is picked",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.onBackground),
    );

    if (isLocationLoading) content = const CircularProgressIndicator();
    return Column(
      children: [
        Container(
          height: 250,
          width: double.infinity,
          alignment: Alignment.center,
          decoration: BoxDecoration(border: Border.all(color: Theme.of(context).colorScheme.primary.withOpacity(0.1))),
          child: content,
        ),
        Row(
          children: [
            TextButton.icon(
              onPressed: getCurrentLocation,
              label: const Text("Use Current Location"),
              icon: const Icon(Icons.location_on),
            ),
            TextButton.icon(
              onPressed: () {},
              label: const Text("Select On Map"),
              icon: const Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
