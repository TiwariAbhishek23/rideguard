import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RideGuardian'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // Open sidebar menu
          },
        ),
      ),
      body: const Center(
        child: Text('Welcome to RideGuardian!'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.home),
              onPressed: () {
                // Handle home button press
              },
            ),
            const SizedBox(width: 20), // Space between buttons
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Handle settings button press
              },
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          // Handle main button press
        },
      ),
    );
  }
}