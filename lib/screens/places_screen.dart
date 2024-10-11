import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:san_favourite_places/providers/fav_places_provider.dart';
import 'package:san_favourite_places/screens/add_place_screen.dart';
import 'package:san_favourite_places/screens/place_detail_screen.dart';

class PlacesScreen extends StatelessWidget {
  const PlacesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Theme.of(context).colorScheme.onSecondary,
      appBar: AppBar(
        title: const Text("Favourite Places"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddPlaceScreen(),
                    ));
              },
              icon: const Icon(Icons.add)),
        ],
      ),
      body: Consumer(
        builder: (context, ref, child) {
          final places = ref.watch(favPlacesProvider);
          if (places.isEmpty) {
            return Center(
              child: Text(
                "There are no places",
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Theme.of(context).colorScheme.onSurface),
              ),
            );
          } else {
            return ListView.builder(
              itemCount: places.length,
              itemBuilder: (context, index) {
                final place = places[index];
                return ListTile(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PlaceDetailScreen(place: place),
                          ));
                    },
                    leading: CircleAvatar(
                      backgroundImage: FileImage(place.image),
                    ),
                    title: Text(place.title,
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(color: Theme.of(context).colorScheme.onSurface)));
              },
            );
          }
        },
      ),
    );
  }
}
