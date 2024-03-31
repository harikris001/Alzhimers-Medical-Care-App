import 'package:alzhcare/locator.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  Position? _position;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    setState(() {
      _isLoading = true;
    });
    final position = await AppLocation.determinePosition();
    setState(() {
      _position = position;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Location Tracking',
          style: TextStyle(color: Colors.grey),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _isLoading?
            const Text('Tracking Location... hold on')
            : const Text('Location Tracker'),
            if (_isLoading)
              const CircularProgressIndicator(),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _getLocation,
              child: const Icon(Icons.location_on),
            ),
            const SizedBox(height: 25,),
            if (!_isLoading)
              const Text('Location Detected',style: TextStyle(fontWeight: FontWeight.bold),),
            if (_position != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Latitude: ${_position!.latitude}'),
                  Text('Longitude: ${_position!.longitude}'),
                ],
              ),
          ],
        ),
      ),
    );
  }
}

