import 'package:comugram/services/GoogleMapsService.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsDetail extends StatefulWidget {
  String desc, id;
  MapsDetail({this.desc, this.id});
  @override
  State<StatefulWidget> createState() => _StateMapsDetail();
}

class _StateMapsDetail extends State<MapsDetail> {
  GoogleMapsService googleMapsService;
  Map<String, dynamic> maps = Map<String, dynamic>();
  final Set<Marker> marker = {};
  LatLng currentPosition;
  @override
  void initState() {
    googleMapsService = GoogleMapsService();
    initMaps();
    super.initState();
  }

  void initMaps() async {
    print(widget.id);
    maps = await googleMapsService.getLatLng(widget.id);
    print(maps['lat']);
    double lat = maps['lat'];
    double lng = maps['lng'];
    currentPosition = LatLng(lat, lng);
    marker.add(
      Marker(
        markerId: MarkerId("${lat},${lng}"),
        position: currentPosition,
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(Object context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.desc),
      ),
      body: maps.length == 0
          ? Center(
              child: CircularProgressIndicator(),
            )
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: currentPosition,
                zoom: 17,
              ),
              markers: marker,
            ),
    );
  }
}
