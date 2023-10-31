import 'package:flutter/material.dart';
import 'package:todo2/Auth/auth.dart';

class NoInternetScreen extends StatelessWidget {
  const NoInternetScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.secondary,
          alignment: Alignment.center,
          title: Icon(
            size: 60,
            color: Colors.redAccent,
            Icons.signal_wifi_off),
          actions: [
            Column(
              children: [
                Text(
                  'You are currently offline. Please check your internet connection and try again.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom( 
                    backgroundColor: Theme.of(context).primaryColor,
                    shadowColor: Theme.of(context).colorScheme.secondary,
                  ),
                    onPressed: () {
                      AuthPage();
                    },
                    child: Text('Retry'))
              ],
            )
          ],
    );
  }
}