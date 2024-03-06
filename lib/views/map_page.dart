import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';

class MapPage extends StatelessWidget {
  final double latitude;
  final double longitude;
  const MapPage({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: OSMFlutter(
          controller: MapController.withPosition(
            initPosition: GeoPoint(
              latitude: latitude,
              longitude: longitude,
            ),
          ),
          osmOption: OSMOption(
            // userTrackingOption: UserTrackingOption(
            //   enableTracking: true,
            //   unFollowUser: false,
            // ),
            zoomOption: const ZoomOption(
              initZoom: 20,
              minZoomLevel: 3,
              maxZoomLevel: 19,
              stepZoom: 1.0,
            ),
            // userLocationMarker: UserLocationMaker(
            //   personMarker: MarkerIcon(
            //     icon: Icon(
            //       Icons.location_history_rounded,
            //       color: Colors.red,
            //       size: 48,
            //     ),
            //   ),
            //   directionArrowMarker: MarkerIcon(
            //     icon: Icon(
            //       Icons.double_arrow,
            //       size: 48,
            //     ),
            //   ),
            // ),
            roadConfiguration: const RoadOption(
              roadColor: Colors.yellowAccent,
            ),
            markerOption: MarkerOption(
                defaultMarker: const MarkerIcon(
              icon: Icon(
                Icons.person_pin_circle,
                color: Colors.blue,
                size: 56,
              ),
            )),
          )),
    );
  }
}
