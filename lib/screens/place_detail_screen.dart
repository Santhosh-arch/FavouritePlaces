import 'package:flutter/material.dart';
import 'package:san_favourite_places/config/config.dart';

import '../models/place.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({required this.place, super.key});

  final Place place;
  String get mapUrl {
    final lat = place.location.lattitude;
    final long = place.location.longitude;
    return "https://maps.googleapis.com/maps/api/staticmap?center=${lat},${long}&zoom=13&size=600x300&maptype=roadmap&markers=color:red%7Clabel:C%7C${lat},${long}&key=${Config.mapApiKey}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(place.title),
      ),
      body: Stack(
        children: [
          Image.file(
            place.image,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Positioned(
              bottom: 0,
              left: 0,
              right: 0,
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
                          Colors.transparent,
                          Colors.black54,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                    child: Text(place.location.address,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface,
                            )),
                  )
                ],
              ))
        ],
      ),
    );
  }
}
