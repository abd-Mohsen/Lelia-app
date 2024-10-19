import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:get/get.dart';

class MapPage extends StatefulWidget {
  final double latitude;
  final double longitude;
  const MapPage({super.key, required this.latitude, required this.longitude});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late MapController mapController;

  //todo: fix this and add marker on the initial position
  @override
  void initState() {
    super.initState();
    mapController = MapController.withPosition(
      initPosition: GeoPoint(
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Add the initial marker after the widget is built
      mapController.addMarker(
        GeoPoint(
          latitude: widget.latitude,
          longitude: widget.longitude,
        ),
        markerIcon: MarkerIcon(
          icon: Icon(
            Icons.location_history_rounded,
            color: Colors.red,
            size: 48,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "موقع النقطة",
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        backgroundColor: cs.primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
        ),
      ),
      body: OSMFlutter(
          controller: mapController,
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
            userLocationMarker: UserLocationMaker(
              personMarker: MarkerIcon(
                icon: Icon(
                  Icons.location_history_rounded,
                  color: Colors.red,
                  size: 48,
                ),
              ),
              directionArrowMarker: MarkerIcon(
                icon: Icon(
                  Icons.double_arrow,
                  size: 48,
                ),
              ),
            ),
            roadConfiguration: const RoadOption(
              roadColor: Colors.yellowAccent,
            ),
            // markerOption: MarkerOption(
            //   defaultMarker: const MarkerIcon(
            //     icon: Icon(
            //       Icons.person_pin_circle,
            //       color: Colors.blue,
            //       size: 56,
            //     ),
            //   ),
            // ),
          )),
    );
  }
}
