import 'dart:io';

import 'package:riverpod/riverpod.dart';
import 'package:san_favourite_places/models/place.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:san_favourite_places/models/place_location.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:sqflite/sqlite_api.dart';

Future<Database> _getDb() async {
  final dbpath = await sql.getDatabasesPath();
  final db = await sql.openDatabase(
    path.join(dbpath, "places.db"),
    onCreate: (db, version) {
      return db.execute(
          "CREATE TABLE fav_places( id TEXT PrimaryKey, title TEXT, image TEXT, lat REAL, lng REAL, address TEXT)");
    },
    version: 1,
  );
  return db;
}

class FavNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  Future<void> loadPlaces() async {
    final db = await _getDb();
    final placesData = await db.query('fav_places');
    final places = placesData.map(
      (row) {
        return Place(
          id: row['id'] as String,
          title: row['title'] as String,
          image: File(row['image'] as String),
          location: PlaceLocation(
            latitude: row['lat'] as double,
            longitude: row['lng'] as double,
            address: row['address'] as String,
          ),
        );
      },
    ).toList();

    state = places;
  }

  Future<bool> addPlace(Place place) async {
    final appDir = await path_provider.getApplicationDocumentsDirectory();
    final filename = path.basename(place.image.path);
    final copiedFile = await place.image.copy("${appDir.path}/$filename");
    place.image = copiedFile;

    final db = await _getDb();
    await db.insert('fav_places', {
      'id': place.id,
      'title': place.title,
      'image': place.image.path,
      'lat': place.location.latitude,
      'lng': place.location.longitude,
      'address': place.location.address,
    });
    state = [...state, place];
    return true;
  }
}

final favPlacesProvider = NotifierProvider<FavNotifier, List<Place>>(
  () {
    return FavNotifier();
  },
);
