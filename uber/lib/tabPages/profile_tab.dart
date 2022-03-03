import 'package:flutter/material.dart';
import 'package:uber/global/global.dart';
import 'package:uber/splashScreen/splash_screen.dart';

class ProfileTabPage extends StatefulWidget {
  const ProfileTabPage({Key? key}) : super(key: key);

  @override
  _ProfileTabPageState createState() => _ProfileTabPageState();
}

class _ProfileTabPageState extends State<ProfileTabPage> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        child: const Text(
          "Deconnexion",
        ),
        onPressed: ()
        {
          // Deconnection
          fAuth.signOut();
          // & redirection vers notre ecran d'acceuil qui contient le logo 'splashScreen/splash_screen.dart', et vu qu'il n'y a plus de session celle ci nous renvera a la page de connection 'authenticaton/login_screen.dart'
          Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
        },
      ),
    );
  }
}



         