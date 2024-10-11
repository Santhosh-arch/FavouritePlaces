import 'package:riverpod/riverpod.dart';
import 'package:san_favourite_places/models/place.dart';

class FavNotifier extends Notifier<List<Place>> {
  @override
  List<Place> build() {
    return [];
  }

  bool addORemovePlace(Place place) {
    if (!state.contains(place)) {
      state = [...state, place];
      return true;
    } else {
      state = state.where((element) => element.id != place.id).toList();
      return false;
    }
  }
}

final favPlacesProvider = NotifierProvider<FavNotifier, List<Place>>(
  () {
    return FavNotifier();
  },
);
