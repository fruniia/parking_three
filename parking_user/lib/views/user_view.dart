import 'package:flutter/material.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:provider/provider.dart';

class UserView extends StatelessWidget {
  const UserView({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = context.read<AuthProvider>();

    if (authService.currentUser == null) {
      return Scaffold(
          body: Center(
            child: Text("You need to login!"),
          ));
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('${authService.currentUser?.name}s page'),
      ),
      body: Center(
          child: Text(
        'Welcome ${authService.currentUser?.name}!',
        style: TextStyle(fontSize: 32),
      )),
    );
  }
}
