import 'dart:io';

import 'package:san_favourite_places/models/place_location.dart';
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  String id;
  String title;
  File image;
  PlaceLocation location;

  Place({required this.title, required this.image, required this.location}) : id = uuid.v4();
}
