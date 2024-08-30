import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:path/path.dart';
import 'package:file_selector/file_selector.dart';

import '../widgets/custom_appbar.dart';

class WelcomePage extends StatefulWidget {
  final FileSystem fs;

  const WelcomePage({super.key, required this.fs});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final GlobalKey _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _key,
      appBar: CustomAppBar(
        titleWidget: const Text("Overture's Scouting App"),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(
              height: 250,
              width: 250,
              child:
                  Icon(Icons.scoreboard, size: 180), // TODO: Replace with logo
            ),
            const Text("Scouting App", style: TextStyle(fontSize: 48)),
            const Text('v0.1.0-alpha', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 64),
            ElevatedButton(
              onPressed: () {
                _showOpenProjectDialog(context);
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(200, 50),
              ),
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Text(
                  'Open Save Location',
                  style: TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOpenProjectDialog(BuildContext context) async {
    String? projectFolder = await getDirectoryPath(
      confirmButtonText: 'Open Project',
      initialDirectory: widget.fs.currentDirectory.path,
    );

    if (!context.mounted) return;

    if (projectFolder != null) {
      if (!widget.fs
          .file(join(projectFolder, 'QRScout_config.json'))
          .existsSync()) {
        showDialog(
          context: _key.currentContext!,
          builder: (context) => AlertDialog(
            title: const Text('Error'),
            content: const Text(
                'The selected folder does not contain a QRScout_config.json file.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        Navigator.pop(context, projectFolder);
      }
    }
  }
}
