import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:san_favourite_places/models/place.dart';
import 'package:san_favourite_places/providers/fav_places_provider.dart';
import 'package:san_favourite_places/screens/place_detail_screen.dart';
import 'package:san_favourite_places/widgets/alert_dialog.dart';

class PlacesList extends ConsumerWidget {
  const PlacesList({
    super.key,
    required this.places,
  });

  final List<Place> places;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          return Dismissible(
            key: Key(place.id),
            onDismissed: (direction) {
              ref.read(favPlacesProvider.notifier).removePlace(place.id);
            },
            confirmDismiss: (direction) {
              return confirmPlaceDeletion(context, place.title, place.location.address);
            },
            direction: DismissDirection.endToStart,
            background: Container(
              alignment: Alignment.centerRight,
              color: Theme.of(context).colorScheme.errorContainer.withOpacity(0.9),
              child: const Padding(
                padding: EdgeInsets.all(16.0),
                child: Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ),
            child: ListTile(
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
                      ?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
              subtitle: Text(place.location.address,
                  style:
                      Theme.of(context).textTheme.bodySmall?.copyWith(color: Theme.of(context).colorScheme.onSurface)),
            ),
          );
        },
      );
    }
  }
}
