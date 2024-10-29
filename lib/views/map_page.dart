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

  @override
  void initState() {
    super.initState();
    // Initialize the map controller with the initial position
    mapController = MapController.withPosition(
      initPosition: GeoPoint(
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    );

    // Use Future.delayed to ensure the map has loaded before adding the marker
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(Duration(milliseconds: 500)); // Adjust if needed
      await _addInitialMarker();
    });
  }

  // Function to add the initial marker
  Future<void> _addInitialMarker() async {
    await mapController.addMarker(
      GeoPoint(
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
      markerIcon: MarkerIcon(
        icon: Icon(
          Icons.location_on,
          color: Colors.red,
          size: 48,
        ),
      ),
    );
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
          zoomOption: const ZoomOption(
            initZoom: 20, // Set closer zoom for a better view
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
        ),
      ),
    );
  }
}
