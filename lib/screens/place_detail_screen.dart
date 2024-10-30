import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:san_favourite_places/config/config.dart';
import 'package:san_favourite_places/providers/fav_places_provider.dart';
import 'package:san_favourite_places/screens/add_place_screen.dart';
import 'package:san_favourite_places/screens/map_screen.dart';
import 'package:san_favourite_places/widgets/alert_dialog.dart';

import '../models/place.dart';

class PlaceDetailScreen extends ConsumerStatefulWidget {
  const PlaceDetailScreen({required this.place, super.key});
  final Place place;
  @override
  ConsumerState<PlaceDetailScreen> createState() {
    return _PlaceDetailScreenState();
  }
}

class _PlaceDetailScreenState extends ConsumerState<PlaceDetailScreen> {
  Place? place;
  String get mapUrl {
    if (place == null) return "";
    final lat = place!.location.latitude;
    final long = place!.location.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=${lat},${long}&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C${lat},${long}&key=${Config.mapApiKey}";
  }

  Future<void> deletePlace(BuildContext context, WidgetRef ref) async {
    final shouldDelete = await confirmPlaceDeletion(context, place!.title, place!.location.address);
    if (shouldDelete == true) {
      await ref.read(favPlacesProvider.notifier).removePlace(place!.id);
      if (context.mounted) Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    place = ref.watch(favPlacesProvider.select(
      (value) => value.where((element) => element.id == widget.place.id).first,
    ));
    return Scaffold(
      appBar: AppBar(
        title: Text(place!.title),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => AddPlaceScreen(
                  placeToUpdate: place,
                ),
              ));
            },
            icon: const Icon(Icons.edit),
          ),
          IconButton(
            onPressed: () {
              deletePlace(context, ref);
            },
            icon: const Icon(Icons.delete),
          )
        ],
      ),
      body: Stack(
        children: [
          Image.file(
            place!.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MapScreen(
                        isSelection: false,
                        place: place!.location,
                      ),
                    )),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      foregroundImage: NetworkImage(mapUrl),
                    ),
                    Container(
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.black26,
                            Colors.black,
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      child: Text(place!.location.address,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: Theme.of(context).colorScheme.onSurface,
                              )),
                    )
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
