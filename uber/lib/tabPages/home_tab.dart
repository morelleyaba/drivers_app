import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uber/assistants/assistant_methods.dart';
import 'package:uber/global/global.dart';

class HomeTabPage extends StatefulWidget {
  const HomeTabPage({Key? key}) : super(key: key);

  @override
  _HomeTabPageState createState() => _HomeTabPageState();
}

class _HomeTabPageState extends State<HomeTabPage> {
  // voir 'https://pub.dev/packages/google_maps_flutter' section 4 V-21
  final Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController? newGoogleMapController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // 1)- trouver ma position
  // creer une instance "driverCurrentPosition" de Position
  Position? driverCurrentPosition;
  var geoLocator = Geolocator();
  // creons une instance ("_locationPermission") de la permission de la location ("LocationPermission") venant de notre package ("geolocator")
  LocationPermission? _locationPermission;

  // 10)- statut du conducteur
  String statusText = "Now OffLine";
  Color buttonColor = const Color(0xFFF57F17);
  bool isDriverActive = false; 

  // le style noir de googleMap
  blackThemeGoogleMap() {
    newGoogleMapController!.setMapStyle('''
                    [
                      {
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#242f3e"
                          }
                        ]
                      },
                      {
                        "featureType": "administrative.locality",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#263c3f"
                          }
                        ]
                      },
                      {
                        "featureType": "poi.park",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#6b9a76"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#38414e"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#212a37"
                          }
                        ]
                      },
                      {
                        "featureType": "road",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#9ca5b3"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#746855"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "geometry.stroke",
                        "stylers": [
                          {
                            "color": "#1f2835"
                          }
                        ]
                      },
                      {
                        "featureType": "road.highway",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#f3d19c"
                          }
                        ]
                      },
                      {
                        "featureType": "transit",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#2f3948"
                          }
                        ]
                      },
                      {
                        "featureType": "transit.station",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#d59563"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "geometry",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.fill",
                        "stylers": [
                          {
                            "color": "#515c6d"
                          }
                        ]
                      },
                      {
                        "featureType": "water",
                        "elementType": "labels.text.stroke",
                        "stylers": [
                          {
                            "color": "#17263c"
                          }
                        ]
                      }
                    ]
                ''');
  }

  // 2)- definir la fonction de demande de permission pour activer la localisation sur l'application
  // acceder a (android/app/src/main/AndroidMainfest.xml) puis coller le code de permission obtenu sur google documentation
  // acceder a (ios/Runner/info.plist) puis vous faites pareil
  checkIfLocationPermissionAllowed() async {
    _locationPermission = await Geolocator.requestPermission();
    // si l'autorisation n'a pas été accepté
    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  // 3)- Definir ma position sur la carte
  locateDriversPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    driverCurrentPosition = cPosition;

    LatLng latLngPosition =
        LatLng(driverCurrentPosition!.latitude, driverCurrentPosition!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleMapController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
    // definir ma position sur le form
    // nous appellons la classe "AssistantMethods" suivie de la fonction "searchAddressForGeographicCoOrdinates" avec en paramettre "driverCurrentPosition" qui represente ma position
    String humanReadableAddress =
        await AssistantMethods.searchAddressForGeographicCoOrdinates(
            driverCurrentPosition!, context);
    print("Votre Adress = " + humanReadableAddress);

    // Pas besoin pour le moment
    // userName = userModelCurrentInfo!.name!;
    // userEmail = userModelCurrentInfo!.email!;
  }

// 4)- vu la demande a été accepté, appelons la fonction
// 5)- allez copiez le dossier ("assitant" de "user_app" qui sera mis a jour)
// 6)- aller copier le dossier "model" de ("user_app") aussi / 7)- faites pareil pour le dossier ("infoHandler")
// 8)- creer une instance de "UserModel" dans global.dart
  @override
  void initState() {
    super.initState();
    // appeler la fonction
    checkIfLocationPermissionAllowed();
  }
// ______________________

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: _kGooglePlex,
          onMapCreated: (GoogleMapController controller) {
            _controllerGoogleMap.complete(controller);
            newGoogleMapController = controller;

            // For black theme google map
            // Ce fichier a été extrait du cours session 4 V-21 / Style en noir de google map
            blackThemeGoogleMap();

            // 9)- Afficher ma position sur la carte
            locateDriversPosition();
          },
        ),
        
          // 11)- UI pour le statut du chauffeur (OffLine / OnLine) => ICI Nous utiliserons beaucoup les condition ternaires
          // Condition d'affichage/ Si le statutText est different de "Now OnLine" declaré plus haut, alors : 
        statusText != "Now OnLine" 
          // Suite de la Condition: que l'ecran devient tout noir 
        ? Container(
          height: MediaQuery.of(context).size.height,
          width: double.infinity,
          color: Colors.black,
          )
          // Suite de la Condition: Sinon l'ecran reste normal
        : Container(),

        // boutton (OffLine / OnLine) du conducteur
        Positioned(
          // Condition/ hauteur du boutton en fonction du statut (OffLine / OnLine)
          top: statusText != "Now OnLine"
          // Si "OffLine" alors boutton au milieu
          ? MediaQuery.of(context).size.height * 0.40
          // sinon boutton juste en haut
          : 25,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: ()
                {
                  // 17)- Appeller la fonction
                  driverIsOnlineNow();
                },
                // couleur du bouton
                style: ElevatedButton.styleFrom(
                  // couleur declaré plus haut
                  primary: buttonColor,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  // Bordure du boutton
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)
                  )
                ),
                // Condition d'affichage / Si la variable "statusText" est different de "Now OnLine" alors :
               child: statusText != "Now OnLine" 
                // Suite de la Condition: affichr un widget text de contenu de la variable "statusText" 
               ? Text(
                    statusText,
                    style: const TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ) 
                // Suite de la Condition: sinon afficher un icon de telephone en haut
               : const Icon(
                    Icons.phonelink_ring,
                    color: Colors.white,
                    size: 16,
                 ),
               )
            ],
          ),
        )
        // 12)- ajouter "flutter_geofire" au packages / Changer les regles de base de donnée sur firebase (V-845) _________________________________
      ],
    );
  }

  // 13)-si le conducteur est (onLine)
  driverIsOnlineNow() async
  {
    // 16)-
    Position pos = await  Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    driverCurrentPosition = pos;

    // "activeDrivers"=> vient des regles modifiées de firebase
    //14)- Envoyer les infos de la position du conducteur dans la base de donnée firebase grace a "Geofire"
    Geofire.initialize("activeDrivers");
    // Geofire.setLocation(id, latitude, longitude); /=> remplacement des valeurs "id, latitude, longitude"
    Geofire.setLocation(
      // "currentFirebaseUser!.uid" l'id du conducteur connecté
      currentFirebaseUser!.uid, 
      driverCurrentPosition!.latitude, 
      driverCurrentPosition!.longitude
      );
      //15)- apres que le '14' soit derouler, le '15' Suivra automatiquement
      DatabaseReference driverPositionRef = FirebaseDatabase.instance.ref()
                        // sur l'enfant "drivers"
                        .child("drivers")
                        // acceder a l'enfant au nom de l'id du conducteur connecté
                        .child(currentFirebaseUser!.uid)
                        // creer un enfant au nom de "newRideStatus"
                        .child("newRideStatus");

      // Ensuite attribuer la valeur "idle" a l'enfant "newRideStatus"
      // dans le cas de "car_details" la valeur "driverCarInfoMap" qu'on avait 'set'(envoyé dans la base de donnée) 
      //etait un map (contenait plusieurs infos), ici c'est juste un 'string' au nom de "idle" qu'on envoie
      driverPositionRef.set("idle");
      driverPositionRef.onValue.listen((event) { });
  }
}
