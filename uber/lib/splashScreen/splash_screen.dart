import 'dart:async';
import 'package:flutter/material.dart';
import 'package:uber/authenticaton/login_screen.dart';
import 'package:uber/global/global.dart';
import 'package:uber/mainScreens/main_screen.dart';


// notre ecran d'acceuil qui contient le logo
class MySplashScreen extends StatefulWidget {
  const MySplashScreen({Key? key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  startTimer() {
    Timer(const Duration(seconds: 3), () async 
    {
      if(await fAuth.currentUser != null)
      {
        // dans le cas ou l'utilisateur vient a peine de s'innscrire, ne pas le rediriger vers la connection mais directement sur le dashboard 'mainScreens/main_screen.dart'
        currentFirebaseUser = fAuth.currentUser;
        Navigator.push(context, MaterialPageRoute(builder: (c)=> const MainScreen()));
      }
      else
      {
      // apres l'ecran qui contient le logo(5 min environ), redirection sur l'ecran d'authentification (connection)
      Navigator.push(context, MaterialPageRoute(builder: (c) => const LoginScreen()));
      }
      
    });
  }

  @override
  void initState() {
    super.initState();

    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Center(
          child:Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Pour l'ajout d'image, on est d'abord ajouter la ligne (61-62) de du fichier 'pubspec.yam'l 
              Image.asset("images/logo_off.png"),
              const SizedBox(height: 10,),
    
              const Text(
                "Vite mon Chauffeur",
                style: TextStyle(
                fontSize: 24,
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
                ),
              )
            ],
          )
        ),
      ),
    );
  }
}
