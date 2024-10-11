import 'dart:io';

import 'package:uuid/uuid.dart';

const uuid = Uuid();

class Place {
  String id;
  String title;
  File image;

  Place({required this.title, required this.image}) : id = uuid.v4();
}
