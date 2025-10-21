import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          SwitchListTile(
            value: brightness == Brightness.dark,
            onChanged: (_) {},
            title: const Text('Dark Mode (System)'),
          ),
          const ListTile(
            title: Text('Privacy Policy'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            title: Text('Terms of Service'),
            trailing: Icon(Icons.chevron_right),
          ),
          const ListTile(
            title: Text('Responsible Gaming'),
            trailing: Icon(Icons.chevron_right),
          ),
        ],
      ),
    );
  }
}
