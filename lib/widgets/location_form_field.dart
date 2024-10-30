import 'package:flutter/material.dart';
import 'package:san_favourite_places/models/place_location.dart';
import 'package:san_favourite_places/widgets/location_field.dart';

class LocationFormField extends StatelessWidget {
  const LocationFormField({this.onSaved, this.validator, this.initialValue, super.key});
  final void Function(PlaceLocation?)? onSaved;
  final String? Function(PlaceLocation?)? validator;
  final PlaceLocation? initialValue;
  @override
  Widget build(BuildContext context) {
    return FormField<PlaceLocation>(
      onSaved: onSaved,
      validator: validator,
      initialValue: initialValue,
      builder: (field) {
        return LocationField(
          initialvalue: initialValue,
          onLocationAdd: (location) => field.didChange(location),
          hasError: field.hasError,
          errorMsg: field.errorText,
        );
      },
    );
  }
}
