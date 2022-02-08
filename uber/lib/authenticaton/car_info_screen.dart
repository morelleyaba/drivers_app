import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:uber/global/global.dart';
import 'package:uber/splashScreen/splash_screen.dart';

class CarInfoScreen extends StatefulWidget {
  const CarInfoScreen({Key? key}) : super(key: key);

  @override
  _CarInfoScreenState createState() => _CarInfoScreenState();
}

class _CarInfoScreenState extends State<CarInfoScreen> {
  TextEditingController carModelTextEditingController = TextEditingController();
  TextEditingController carNumberTextEditingController =
      TextEditingController();
  TextEditingController carColorTextEditingController = TextEditingController();

  List<String> carTypesList = ["BMW", "PEUGEOT", "TOYOTA"];
  String? selectedCarType;

  saveCarInfo()
  {
    Map driverCarInfoMap = 
    {
      "car_color": carColorTextEditingController.text.trim(),
      "car_number": carNumberTextEditingController.text.trim(),
      "car_model": carModelTextEditingController.text.trim(),
      "type": selectedCarType,
    };

    DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
    driversRef.child(currentFirebaseUser!.uid).child("car_details").set(driverCarInfoMap);

    print("Les details du vehicule ont bien été sauvegardés, Felicitation");
    // Redirection vers notre ecran d'acceuil qui contient le logo
    Navigator.push(context, MaterialPageRoute(builder: (c)=> const MySplashScreen()));
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [


            const SizedBox(
              height: 24,
            ),


            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Image.asset("images/logo1.png"),
            ),


            const SizedBox(
              height: 10,
            ),


            const Text(
              "Write car Detail",
              style: TextStyle(
                fontSize: 24,
                color: Colors.grey,
                fontWeight: FontWeight.bold,
              ),
            ),


            TextField(
              controller: carModelTextEditingController,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Car Model",
                hintText: "Car Model",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                // les styles
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),


            TextField(
              controller: carNumberTextEditingController,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Car Number",
                hintText: "Car Number",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                // les styles
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),


            TextField(
              controller: carColorTextEditingController,
              style: const TextStyle(
                color: Colors.grey,
              ),
              decoration: const InputDecoration(
                labelText: "Car Color",
                hintText: "Car Color",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                ),
                // les styles
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),


            const SizedBox(
              height: 10,
            ),
            

            DropdownButton(
                  iconSize: 26,
                  dropdownColor: Colors.white,
              hint: const Text(
                "Please chose a car Type",
                style: TextStyle(
                  fontSize: 14.0,
                  color: Colors.grey,
                ),
              ),
              value: selectedCarType,
              onChanged: (newValue) 
              {
                setState(() {
                  selectedCarType = newValue.toString();
                });
              },
              // Liste deroulante, voir plus haut la liste des elements a choisir a été creer labas
              items: carTypesList.map((car) {
                return DropdownMenuItem(
                  child: Text(
                  car,
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
                value: car,
                );
              }).toList(),
            ),

            const SizedBox(height: 20,),

            ElevatedButton(
              onPressed: (){
                // clicker sur le boutton de 'Create Account' renvoie a notre ecran qui contient les infos du taxi
                // Navigator.push(context, MaterialPageRoute(builder: (c) => const CarInfoScreen()));
                  if(carColorTextEditingController.text.isNotEmpty
                      && carNumberTextEditingController.text.isNotEmpty
                      && carModelTextEditingController.text.isNotEmpty && selectedCarType != null)
                  {
                    saveCarInfo();
                  }                

              },
              // Style du boutton
              style: ElevatedButton.styleFrom(
                primary: Colors.lightGreenAccent,
              ),
              // Style du text du boutton
               child: const Text(
                 "Save Now",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 18,
                  ),
               ),
              ),
          
            
          ],
        ),
      ),
    );
  }
}
