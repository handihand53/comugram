import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as LocationManager;

class GoogleMapsService {
  final homeScaffoldKey = GlobalKey<ScaffoldState>();
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: "AIzaSyDfvca1s0MSW3LBgByR9SlspqVP_Fkg_Ko");

  Future<Map<String, dynamic>> getLatLng(String id) async {
    Map<String, dynamic> temp = Map<String, dynamic>();
    PlacesDetailsResponse detail = await _places.getDetailsByPlaceId(id);
    final lat = detail.result.geometry.location.lat;
    final lng = detail.result.geometry.location.lng;
    temp['lat'] = lat;
    temp['lng'] = lng;
    return temp;
  }

  Future<Prediction> getPrediction(BuildContext context) async {
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: "AIzaSyDfvca1s0MSW3LBgByR9SlspqVP_Fkg_Ko",
      onError: onError,
      mode: Mode.fullscreen,
      language: "id",
      components: [Component(Component.country, "id")],
    );
    return p;
  }

  Future<LatLng> getUserLocation() async {
    LocationManager.LocationData currentLocation;
    final location = LocationManager.Location();
    try {
      currentLocation = await location.getLocation();
      final lat = currentLocation.latitude;
      final lng = currentLocation.longitude;
      final center = LatLng(lat, lng);
      return center;
    } on Exception {
      currentLocation = null;
      return null;
    }
  }

  void onError(PlacesAutocompleteResponse response) {
    homeScaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }
}
