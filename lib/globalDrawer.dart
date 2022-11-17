import 'package:flutter/material.dart';

class GlobalDrawer extends StatelessWidget {
  const GlobalDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.deepPurple,
            ),
            child: Text(
              'Drawer Header',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add_circle),
            title: const Text('Counter'),
            onTap: () {
              Navigator.pushNamed(context, '/counter');
            },
          ),
          ListTile(
            leading: const Icon(Icons.note_alt),
            title: const Text('Neural Numbers'),
            onTap: () {
              Navigator.pushNamed(context, '/neuralNumbers');
            },
          ),
          const ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}