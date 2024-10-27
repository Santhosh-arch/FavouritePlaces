import 'package:flutter/material.dart';
import 'package:san_favourite_places/models/place.dart';
import 'package:san_favourite_places/screens/place_detail_screen.dart';

class PlacesList extends StatelessWidget {
  const PlacesList({
    super.key,
    required this.places,
  });

  final List<Place> places;

  @override
  Widget build(BuildContext context) {
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
                style:
                    Theme.of(context).textTheme.titleMedium?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            subtitle: Text(place.location.address,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
          );
        },
      );
    }
  }
}
