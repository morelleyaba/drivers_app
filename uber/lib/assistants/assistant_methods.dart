import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uber/assistants/request_assistant.dart';
import 'package:uber/global/global.dart';
import 'package:uber/infoHandler/app_info.dart';
import 'package:uber/models/direction_details_info.dart';
import 'package:uber/models/directions.dart';
import 'package:uber/models/user_model.dart'; 
import 'package:uber/global/map_key.dart';

class AssistantMethods {

  static Future<String> searchAddressForGeographicCoOrdinates(Position position, context) async
  {
    // video 536 / 419, geocoding.com
    // creer notre fonction "searchAddressForGeographicCoOrdinates" (prenant en paramettre notre position sur la carte) qui se chargera de
    // trouver notre position et l'afficher sur le formulaire de l'interface "coté point de depart"
    String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    String humanReadableAddress="";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if(requestResponse != "Error Occurred, Failed. No Response.")
    {
      humanReadableAddress = requestResponse["results"][0]["formatted_address"];

      // Nous avons creéer une fonction "Directions" dans Directions.dart , nous l'appelons alors en lui affectant des valeurs de position et autres
      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationLatitude = position.latitude;
      userPickUpAddress.locationLongitude = position.longitude;
      userPickUpAddress.locationName = humanReadableAddress;

      Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadableAddress;
  }
  
  static void readCurrentOnlineUserInfo() async 
  {
    // Vous pouvez également obtenir l'utilisateur actuellement connecté en utilisant la propriété "currentUser" .
    // Si un utilisateur n'est pas connecté, "currentUser" est null 

    // Pour obtenir les informations de profil d'un utilisateur,
    // utilisez les propriétés d'une instance de "currentFirebaseUser"(objet creer par moi)
    currentFirebaseUser = fAuth.currentUser;

    DatabaseReference userRef = FirebaseDatabase.instance
        .ref()
        .child("users")
        .child(currentFirebaseUser!.uid);

    // lire les données
    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);

        // print("nom = "+ userModelCurrentInfo!.name.toString());
        // print("email = "+ userModelCurrentInfo!.email.toString());
      }
    });
  }
  
    static Future<DirectionDetailsInfo?> obtainOriginToDestinationDirectionDetails(LatLng origionPosition, LatLng destinationPosition) async
  {
    String urlOriginToDestinationDirectionDetails = "https://maps.googleapis.com/maps/api/directions/json?origin=${origionPosition.latitude},${origionPosition.longitude}&destination=${destinationPosition.latitude},${destinationPosition.longitude}&key=$mapKey";

    var responseDirectionApi = await RequestAssistant.receiveRequest(urlOriginToDestinationDirectionDetails);

    if(responseDirectionApi == "Error Occurred, Failed. No Response.")
    {
      return null;
    }

    DirectionDetailsInfo directionDetailsInfo = DirectionDetailsInfo();
    directionDetailsInfo.e_points = responseDirectionApi["routes"][0]["overview_polyline"]["points"];

    directionDetailsInfo.distance_text = responseDirectionApi["routes"][0]["legs"][0]["distance"]["text"];
    directionDetailsInfo.distance_value = responseDirectionApi["routes"][0]["legs"][0]["distance"]["value"];

    directionDetailsInfo.duration_text = responseDirectionApi["routes"][0]["legs"][0]["duration"]["text"];
    directionDetailsInfo.duration_value = responseDirectionApi["routes"][0]["legs"][0]["duration"]["value"];

    return directionDetailsInfo;
  }
  
}
