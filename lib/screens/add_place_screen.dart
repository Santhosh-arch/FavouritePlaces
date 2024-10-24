import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:san_favourite_places/models/place.dart';
import 'package:san_favourite_places/models/place_location.dart';
import 'package:san_favourite_places/providers/fav_places_provider.dart';
import 'package:san_favourite_places/widgets/location_field.dart';

import '../widgets/image_field.dart';

class AddPlaceScreen extends ConsumerWidget {
  AddPlaceScreen({super.key});
  final formKey = GlobalKey<FormState>();
  String? place = "";
  File? selectedImage;
  PlaceLocation? selectedLocation;

  void onImageSelection(File file) {
    selectedImage = file;
  }

  void onLocationAdd(PlaceLocation? location) {
    selectedLocation = location;
  }

  void addPlace(WidgetRef ref) {
    final favProvider = ref.read(favPlacesProvider.notifier);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      if (selectedImage != null && selectedLocation != null) {
        favProvider.addORemovePlace(Place(
          title: place!,
          image: selectedImage!,
          location: selectedLocation!,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context, ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Place"),
      ),
      body: SingleChildScrollView(
        child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("Name"),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) {
                      if (value?.trim().isNotEmpty == true) {
                        return null;
                      } else {
                        return "Name cannot be empty or only contain spaces";
                      }
                    },
                    onSaved: (newValue) {
                      place = newValue;
                    },
                  ),
                  const SizedBox(height: 16),
                  ImageFieldWidget(
                    onImageSelection: onImageSelection,
                  ),
                  const SizedBox(height: 16),
                  LocationField(
                    onLocationAdd: onLocationAdd,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      addPlace(ref);
                      Navigator.pop(context);
                    },
                    label: const Text("Add Place"),
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
