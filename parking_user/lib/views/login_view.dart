import 'package:flutter/material.dart';
import 'package:parking_shared_logic/parking_shared_logic.dart';
import 'package:parking_shared_ui/parking_shared_ui.dart';
import 'package:parking_user/views/index.dart';
import 'package:parking_user/widgets/index.dart';
import 'package:provider/provider.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final _key = GlobalKey<FormState>();
  final TextEditingController _ssnController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(builder: (context, authService, child) {
      if (authService.status == UserAuthStatus.notAuthenticated &&
          authService.currentUser == null) {
            
        authService.logout();
      }

      return Center(
        child: Form(
          key: _key,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 350),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('Welcome to \nParking app'),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: _ssnController,
                  enabled: authService.status != UserAuthStatus.inProgress,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.abc_rounded),
                      labelText: 'Socialsecuritynumber'),
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter socialsecuritynumber'
                      : null,
                ),
                const SizedBox(
                  height: 16,
                ),
                const PasswordField(),
                const SizedBox(
                  height: 16,
                ),
                authService.status == UserAuthStatus.inProgress
                    ? const CircularProgressIndicator()
                    : ElevatedButton(
                        onPressed: () async {
                          if (_key.currentState!.validate()) {
                            final authService = context.read<AuthProvider>();
                            try {
                              await authService.login(_ssnController.text);
                              if (authService.status ==
                                      UserAuthStatus.authenticated &&
                                  context.mounted) {
                                showCustomSnackBar(context,
                                    '${authService.currentUser?.name ?? 'User'} - Logged in successfully',
                                    type: 'success');

                                if (context.mounted) {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const NavigationView()));
                                }
                              } else if (authService.status ==
                                  UserAuthStatus.notAuthenticated) {
                                if (context.mounted) {
                                  showCustomSnackBar(context,
                                      'Authentication failed. Please try again.',
                                      type: 'error');
                                }
                              }
                            } catch (e) {
                              if (context.mounted) {
                                showCustomSnackBar(
                                    context, 'Error: ${e.toString()}',
                                    type: 'error');
                              }
                            }
                          }
                        },
                        child: const Text('Login')),
                const SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    authService.logout();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationWidget(),
                      ),
                    );
                  },
                  child: const Text(
                    'Don\'t have an account? Register here.',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
