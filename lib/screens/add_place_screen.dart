import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:san_favourite_places/models/place.dart';
import 'package:san_favourite_places/models/place_location.dart';
import 'package:san_favourite_places/providers/fav_places_provider.dart';
import 'package:san_favourite_places/widgets/image_form_field.dart';
import 'package:san_favourite_places/widgets/location_form_field.dart';

class AddPlaceScreen extends ConsumerWidget {
  AddPlaceScreen({super.key, this.placeToUpdate});
  final formKey = GlobalKey<FormState>();
  final Place? placeToUpdate;
  String? place = "";
  File? selectedImage;
  PlaceLocation? selectedLocation;

  void onImageSelection(File? file) {
    selectedImage = file;
  }

  void onLocationAdd(PlaceLocation? location) {
    selectedLocation = location;
  }

  void addPlace(WidgetRef ref, BuildContext context) {
    final favProvider = ref.read(favPlacesProvider.notifier);
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (selectedLocation == null && selectedImage == null) return;

      if (placeToUpdate == null) {
        favProvider.addPlace(Place(
          title: place!,
          image: selectedImage!,
          location: selectedLocation!,
        ));
      } else {
        favProvider.updatePlace(Place(
          id: placeToUpdate!.id,
          title: place!,
          image: selectedImage!,
          location: selectedLocation!,
        ));
      }
      Navigator.pop(context);
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
                    initialValue: placeToUpdate?.title,
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
                  ImageFormField(
                    initialValue: placeToUpdate?.image,
                    validator: (imgFile) {
                      if (imgFile == null) return "Please select an Image";

                      return null;
                    },
                    onSaved: onImageSelection,
                  ),
                  // ImageFieldWidget(
                  //   onImageSelection: onImageSelection,
                  // ),
                  const SizedBox(height: 16),
                  LocationFormField(
                    initialValue: placeToUpdate?.location,
                    validator: (location) {
                      if (location == null) return "Please select Location";
                      return null;
                    },
                    onSaved: onLocationAdd,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      addPlace(ref, context);
                    },
                    label: placeToUpdate == null ? const Text("Add Place") : const Text("Update Place"),
                    icon: const Icon(Icons.add),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
