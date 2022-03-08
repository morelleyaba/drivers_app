import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:uber/models/user_model.dart';



final FirebaseAuth fAuth = FirebaseAuth.instance;
User? currentFirebaseUser;
// video 341 a revoir connection firebase
// 651 EN pause
// 338
// 078 Api maps
// video 64 N 10 min 24

 
// creer une instance(objet) "userModelCurrentInfo" de la classe "userModel"[issus du fichier userModel.dart]
// qui pourra alors a son tour beneficier des methodes et proprietés de la classe "userModel",
// A la base c'est "objet.methode()" ou "objet.proprieté"
// dans notre cas on a faire a un "objet.proprieté" => "userModelCurrentInfo.email" dont
// ["userModelCurrentInfo" etant une instance de la class "UserModel"] &
// & ["email" etant une proprietté de la class "UserModel"]
// on aurait egalement pu faire 
//- "[UserModel userModelCurrentInfo = new UserModel();]" au lieu de :
//- "[UserModel? userModelCurrentInfo;]"

UserModel? userModelCurrentInfo;
// video 038 firebase
// 338
// 532 Billing
// 743 permission localisation
// 078 Api maps
// geocoding 536
// 751 provider
//  132 from where destination
//  076 recherche de destination
// derniere video de la session 13 Oublié de telecharger sur udemy V-430 / Afficher la destination
// 186 Affichage du tracage du chemin
//  070 evolution

StreamSubscription<Position>? streamSubscriptionPosition;