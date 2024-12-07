import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // HTTP package
import 'package:location/location.dart'; // Location package
import 'package:url_launcher/url_launcher.dart'; // For launching SMS app

import '../settings/settings_view.dart';
import 'sample_item.dart';

class SampleItemListView extends StatefulWidget {
  const SampleItemListView({
    super.key,
    this.items = const [SampleItem(1), SampleItem(2), SampleItem(3)],
  });

  static const routeName = '/';

  final List<SampleItem> items;

  @override
  State<SampleItemListView> createState() => _SampleItemListViewState();
}

class _SampleItemListViewState extends State<SampleItemListView> {
  final String esp32Url = "http://192.168.71.31"; // Replace with ESP32 IP
  Timer? timer;

  @override
  void initState() {
    super.initState();
    // Start a timer to periodically check the ESP32 status
    timer = Timer.periodic(
      const Duration(seconds: 15), // Adjust time interval as needed
      (Timer t) => _checkEsp32Status(),
    );
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEsp32Status() async {
    try {
      final response = await http.get(Uri.parse(esp32Url));
      if (response.statusCode == 200) {
        // Send emergency message if the status code is 200
        await _sendEmergencyMessage();
      } else {
        print("ESP32 returned status code: ${response.statusCode}");
      }
    } catch (e) {
      print("Error checking ESP32 status: $e");
    }
  }

  Future<void> _sendEmergencyMessage() async {
    final location = Location();
    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    // Check if location services are enabled
    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return; // Cannot proceed without location services
      }
    }

    // Check for location permission
    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        return; // Cannot proceed without permission
      }
    }

    // Fetch the current location
    locationData = await location.getLocation();

    final message =
        "Hi, I am Abhishek. My location is: https://maps.google.com/?q=${locationData.latitude},${locationData.longitude}. Please save me!";

    final smsUrl = Uri(
      scheme: 'sms',
      path: '8595695568', // Emergency contact number
      queryParameters: {'body': message},
    );

    if (await canLaunch(smsUrl.toString())) {
      await launch(smsUrl.toString());
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Could not send message.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD81B60),
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () {},
        ),
        title: const Text(
          'Rideguardian',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 70,
                backgroundImage: AssetImage('assets/images/flutter_logo.png'),
              ),
            ),
            const SizedBox(height: 20.0),
            Card(
              elevation: 4.0,
              margin: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 16.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Name: Abhishek Kumar',
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Address: 123 Main Street, Springfield, IL',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Emergency Contact: John Doe - +1 (123) 456-7890',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Blood Group: O+',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Allergies: Penicillin, Nuts',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 10.0),
                    const Text(
                      'Medical Conditions: Hypertension, Diabetes',
                      style: TextStyle(fontSize: 16.0),
                    ),
                    const SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/healthDetails');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                        child: const Text('View Details'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ClipOval(
                child: Material(
                  color: Colors.red,
                  child: InkWell(
                    onTap: () {
                      // End call action
                    },
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.call_end, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: const Color(0xFF00C853),
                  child: InkWell(
                    onTap: () {
                      // Make call action
                    },
                    child: const SizedBox(
                      width: 80,
                      height: 80,
                      child: Icon(Icons.call, color: Colors.white, size: 40),
                    ),
                  ),
                ),
              ),
              ClipOval(
                child: Material(
                  color: Colors.blue,
                  child: InkWell(
                    onTap: () {
                      _sendEmergencyMessage();
                    },
                    child: const SizedBox(
                      width: 50,
                      height: 50,
                      child: Icon(Icons.location_on, color: Colors.white, size: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
