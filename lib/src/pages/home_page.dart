import 'package:flutter/material.dart';
import 'package:file/file.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/prefs.dart';
import '../widgets/custom_appbar.dart';
import '../controller/settings_controller.dart';
import 'settings_page.dart';
import 'welcome_page.dart';
import 'insert_data_page.dart';

class HomePage extends StatefulWidget {
  final SettingsController settingsController;
  final SharedPreferences prefs;
  final FileSystem fs;

  const HomePage(
      {required this.settingsController,
      required this.prefs,
      required this.fs,
      super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  final GlobalKey _key = GlobalKey();
  Directory? _projectDir;
  final PageController _pageController = PageController();
  int _selectedPage = 0;

  FileSystem get fs => widget.fs;

  @override
  void initState() {
    super.initState();

    _loadWait().then((_) async {
      String? projectDir = widget.prefs.getString(PrefsKeys.currentProjectDir);
      if (projectDir == null ||
          !fs.directory(projectDir).existsSync() ||
          !fs.file(join(projectDir, 'QRScout_config.json')).existsSync()) {
        projectDir = await Navigator.push(
          _key.currentContext!,
          PageRouteBuilder(
            pageBuilder: (context, anim1, anim2) => WelcomePage(fs: fs),
            transitionDuration: Duration.zero,
            reverseTransitionDuration: Duration.zero,
          ),
        );
      }
      _initFromDir(projectDir!);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _key,
        appBar: CustomAppBar(
          titleWidget: const Text("Overture's Scouting App"),
        ),
        drawer: _projectDir == null ? null : _buildDrawer(context),
        body: _buildBody(context));
  }

  Widget _buildDrawer(BuildContext context) {
    return NavigationDrawer(
      selectedIndex: _selectedPage,
      onDestinationSelected: (idx) {
        setState(() {
          _selectedPage = idx;
          _pageController.animateToPage(_selectedPage,
              duration: const Duration(milliseconds: 150),
              curve: Curves.easeInOut);
        });
      },
      children: const [
        DrawerHeader(
            child: Center(
          child: Stack(
            children: [
              Icon(Icons.pending, size: 100), // TODO: Replace with logo
            ],
          ),
        )),
        NavigationDrawerDestination(
          label: Text('Home'),
          icon: Icon(Icons.home),
        ),
        NavigationDrawerDestination(
          label: Text('Settings'),
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Widget _buildBody(BuildContext context) {
    if (_projectDir != null) {
      return Center(
          child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const InsertDataPage(),
          SettingsView(controller: widget.settingsController),
        ],
      ));
    } else {
      return Container();
    }
  }

  Future<void> _loadWait() async {
    await Future.delayed(const Duration(seconds: 1));
  }

  void _initFromDir(String projectDir) async {
    widget.prefs.setString(PrefsKeys.currentProjectDir, projectDir);

    setState(() {
      _projectDir = fs.directory(projectDir);
    });
  }
}
