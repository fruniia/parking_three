import 'package:flutter/material.dart';
import 'package:parking_admin/views/administration_view.dart';
import 'package:parking_admin/views/start_view.dart';

void main() {
  runApp(const ParkingAdmin());
}

class ParkingAdmin extends StatelessWidget {
  const ParkingAdmin({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Parking app',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.greenAccent),
        useMaterial3: true,
      ),
      home: const NavigationView(),
    );
  }
}

class NavigationView extends StatefulWidget {
  const NavigationView({super.key});

  @override
  State<NavigationView> createState() => _NavigationViewState();
}

class _NavigationViewState extends State<NavigationView> {
  int _selectedIndex = 0;
  NavigationRailLabelType labelType = NavigationRailLabelType.all;

  var options = const <NavigationRailDestination>[
    NavigationRailDestination(icon: Icon(Icons.home), label: Text('Home')),
    NavigationRailDestination(
        icon: Icon(Icons.local_parking), label: Text('Administration')),
  ];

  var pages = const [StartPageView(), AdministrationView()];

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (_selectedIndex) {
      case 0:
        page = const StartPageView();
        break;
      case 1:
        page = const AdministrationView();
        break;
      default:
        throw UnimplementedError('no widget for $_selectedIndex');
    }
    
    return Scaffold(
      body: Row(
        children: <Widget>[
          NavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (int index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            labelType: labelType,
            destinations: options,
          ),
          const VerticalDivider(
            thickness: 1,
            width: 1,
          ),
          Expanded(child: page)
        ],
      ),
    );
  }
}
