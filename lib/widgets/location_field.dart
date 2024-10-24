import "dart:convert";

import "package:flutter/material.dart";
import "package:google_maps_flutter/google_maps_flutter.dart";
import "package:location/location.dart";
import "package:http/http.dart" as http;
import "package:san_favourite_places/config/config.dart";
import "package:san_favourite_places/models/place_location.dart";
import "package:san_favourite_places/screens/map_screen.dart";

class LocationField extends StatefulWidget {
  const LocationField({required this.onLocationAdd, super.key});

  final void Function(PlaceLocation?) onLocationAdd;
  @override
  State<LocationField> createState() => _LocationFieldState();
}

class _LocationFieldState extends State<LocationField> {
  PlaceLocation? selectedLocation;
  bool isLocationLoading = false;

  String get mapUrl {
    return "https://maps.googleapis.com/maps/api/staticmap?center=${selectedLocation?.latitude},${selectedLocation?.longitude}&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C${selectedLocation?.latitude},${selectedLocation?.longitude}&key=${Config.mapApiKey}";
  }

  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    setState(() {
      isLocationLoading = true;
    });

    try {
      locationData = await location.getLocation();
      if (locationData.latitude == null || locationData.longitude == null) {
        throw "Unable to get current location";
      }
      savePlaceLocation(locationData.latitude!, locationData.longitude!);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unable to get current location")));
      }
    } finally {
      setState(() {
        isLocationLoading = false;
      });
    }
  }

  Future<void> onSelectOnMap() async {
    final selectedLatlng = await Navigator.push<LatLng>(
        context,
        MaterialPageRoute(
          builder: (context) => const MapScreen(isSelection: true),
        ));

    if (selectedLatlng == null) return;
    try {
      setState(() {
        isLocationLoading = true;
      });
      savePlaceLocation(selectedLatlng.latitude, selectedLatlng.longitude);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Unable to get location address")));
      }
    } finally {
      setState(() {
        isLocationLoading = false;
      });
    }
  }

  Future<void> savePlaceLocation(double lat, double lng) async {
    final jsonRes = await http
        .get(Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=${Config.mapApiKey}"));
    final res = jsonDecode(jsonRes.body);
    final address = res["results"][0]["formatted_address"];
    setState(() {
      selectedLocation = PlaceLocation(latitude: lat, longitude: lng, address: address);
      isLocationLoading = false;
    });

    widget.onLocationAdd(selectedLocation);
  }

  @override
  Widget build(BuildContext context) {
    Widget content = Text(
      "No location is picked",
      style: Theme.of(context).textTheme.bodyLarge!.copyWith(color: Theme.of(context).colorScheme.primary),
    );

    if (isLocationLoading) {
      content = const CircularProgressIndicator();
    } else if (selectedLocation != null) {
      content = Image.network(
        mapUrl,
        height: double.infinity,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }

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
              onPressed: onSelectOnMap,
              label: const Text("Select On Map"),
              icon: const Icon(Icons.map),
            )
          ],
        )
      ],
    );
  }
}
