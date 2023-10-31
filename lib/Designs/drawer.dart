import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:todo2/Pages/loginPage.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: HexColor('#29EB00'),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              DrawerHeader(child: Icon(Icons.favorite)),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListTile(
              leading: Icon(Icons.home),
              title: Text('H O M E'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.all(24.0),
          //   child: ListTile(
          //     leading: Icon(Icons.person),
          //     title: Text('P R O F I L E'),
          //     onTap: () {
          //       Navigator.pop(context);
          //       Navigator.push(context, MaterialPageRoute(builder: (context) {
          //         return MyProfile();
          //       },));
          //     },
          //   ),
          // ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ListTile(
              leading: Icon(Icons.logout),
              title: Text('L O G O U T'),
              onTap: () async{
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginPage(),));
              },
            ),
          ),
        ],
      ),
    );
  }
}
