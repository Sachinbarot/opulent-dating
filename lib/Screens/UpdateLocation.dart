// ignore_for_file: library_private_types_in_public_api, file_names, avoid_print, prefer_const_constructors

import 'package:flutter/material.dart';
// import 'package:flutter_geocoder/geocoder.dart';
import 'package:flutter_mapbox_autocomplete/flutter_mapbox_autocomplete.dart';
import 'package:hookup4u/Screens/seach_location.dart';
import 'package:hookup4u/util/color.dart';
import 'package:location/location.dart' as loc;
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class UpdateLocation extends StatefulWidget {
  const UpdateLocation({super.key});

  @override
  _UpdateLocationState createState() => _UpdateLocationState();
}

class _UpdateLocationState extends State<UpdateLocation> {
  Map? _newAddress;
  @override
  void initState() {
    getLocationCoordinates().then((updateAddress) {
      setState(() {
        _newAddress = updateAddress!;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: primaryColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: ListTile(
          title: Text(
            "Use current location".tr().toString(),
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Text(_newAddress != null
              ? _newAddress!['PlaceName'] ?? 'Fetching..'.tr().toString()
              : 'Unable to load...'.tr().toString()),
          leading: const Icon(
            Icons.location_searching_rounded,
            color: Colors.white,
          ),
          onTap: () async {
            if (_newAddress == null) {
              await getLocationCoordinates().then((updateAddress) {
                print(updateAddress);
                setState(() {
                  _newAddress = updateAddress!;
                });
              });
            } else {
              print("-------object");
              Navigator.pop(context, _newAddress);
            }
          },
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height * .6,
        child: MapBoxAutoCompleteWidget(
          language: 'en',
          closeOnSelect: false,
          country: 'In',
          apiKey: mapboxApi,
          limit: 10,
          hint: 'Enter your city name'.tr().toString(),
          onSelect: (place) {
            Map obj = {};
            obj['PlaceName'] = place.placeName;
            obj['latitude'] = place.geometry!.coordinates![1];
            obj['longitude'] = place.geometry!.coordinates![0];
            Navigator.pop(context, obj);
          },
        ),
      ),
    );
  }
}

Future<Map<String, dynamic>?> getLocationCoordinates() async {
  bool serviceEnabled;
  LocationPermission permission;

  // Check if location services are enabled
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    await Geolocator.openLocationSettings();
    return null;
  }

  // Check permission
  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      return null;
    }
  }

  if (permission == LocationPermission.deniedForever) {
    return null;
  }

  // Get current position
  Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high);

  // Get human-readable address
  List<Placemark> placemarks =
      await placemarkFromCoordinates(position.latitude, position.longitude);
  Placemark place = placemarks[0];

  String address =
      "${place.locality}, ${place.administrativeArea}, ${place.country}";

  return {
    'latitude': position.latitude,
    'longitude': position.longitude,
    'PlaceName': address,
  };
}


// Future coordinatesToAddress({latitude, longitude}) async {
//   try {
//     Map<String, dynamic> obj = {};
//     final coordinates = Coordinates(latitude, longitude);
//     List<Address> result =
//         await Geocoder.local.findAddressesFromCoordinates(coordinates);
//     String currentAddress =
//         "${result.first.locality ?? ''} ${result.first.subLocality ?? ''} ${result.first.subAdminArea ?? ''} ${result.first.countryName ?? ''}, ${result.first.postalCode ?? ''}";

//     print(currentAddress);
//     obj['PlaceName'] = currentAddress;
//     obj['latitude'] = latitude;
//     obj['longitude'] = longitude;

//     return obj;
//   } catch (_) {
//     print(_);
//     return null;
//   }
// }
