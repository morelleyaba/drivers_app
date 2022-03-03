import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uber/authenticaton/car_info_screen.dart';
import 'package:uber/authenticaton/login_screen.dart';
import 'package:uber/global/global.dart';
import 'package:uber/widgets/progress_dialog.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// Notre ecran qui contient le formulaire d'authentification
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();

// _________________________message FlutterToast Deuxieme methode
late FToast fToast;

@override
void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
}
String? message;

// j'ai dû créer une fonction _showToast avec pour paramètres message que j'appelle a chaque fois
_showToast({required String message}) {
    Widget toast = Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.redAccent,
        ),
        child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            const SizedBox(
            width: 12.0,
            ),
            Text(message,),
        ],
        ),
    );


    fToast.showToast(
        child: toast,
        gravity: ToastGravity.TOP,
        toastDuration: const Duration(seconds: 2),
    );
    
}
// ________________________

  // validation
  validateForm() {
    if (nameTextEditingController.text.length < 3) 
    {
      // Fluttertoast.showToast(msg: "name must be atleast 3 Characters.");
      _showToast(message: 'Veuillez renseignez votre nom svp');
      
    }else if(!emailTextEditingController.text.contains("@"))
    {
      _showToast(message: "address Email n'est pas valide.");
    }
    else if(phoneTextEditingController.text.isEmpty)
    {
      _showToast(message: "Numero de telephone n'est pas valid.");
    }
    else if(passwordTextEditingController.text.length < 6)
    {
      _showToast(message: "Mot de pass non valid.");
    }
    else
    {
      saveDriverInfoNow();
    }
  }

    saveDriverInfoNow()async
    {
      showDialog
      (
        context: context,
        barrierDismissible: false,
        builder: (BuildContext c)
        {
          // Retourner le widget se trouvant au 'widgets/progress_dialog.dart'
          return ProgressDialog(message: "Veuillez patienter...",);
        }
      );

      // ignore: unused_local_variable
      final User? firebaseUser = (
        // 'createUserWithEmailAndPassword' permet de s'inscrire avec firebase
      await fAuth.createUserWithEmailAndPassword(
        email: emailTextEditingController.text.trim(),
        password: passwordTextEditingController.text.trim(),
      ).catchError((msg){
        Navigator.pop(context);
        // le compte existe deja
        // _showToast(message: "Error: " + msg.toString());
        _showToast(message: "Ce compte existe deja");
      })
    ).user;

    if(firebaseUser != null)
    {
      Map driverMap = 
      {
        "id": firebaseUser.uid,
        "name": nameTextEditingController.text.trim(),
        "email": emailTextEditingController.text.trim(),
        "phone": phoneTextEditingController.text.trim(),
      };

      DatabaseReference driversRef = FirebaseDatabase.instance.ref().child("drivers");
      driversRef.child(firebaseUser.uid).set(driverMap);

      currentFirebaseUser = firebaseUser;
      // _showToast(message: "Le compte a été créé");
      // redirection sur notre ecran d'acceuil qui contient le logo 
      Navigator.push(context, MaterialPageRoute(builder: (c)=> const CarInfoScreen()));
    }
    else
    {
      Navigator.pop(context);
      _showToast(message: "Le compte n'a pas pu etre creer");
    }      

    }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.asset("images/logo_off.png"),
            ),
            const SizedBox(
              height: 10,
            ),
            const Text(
              "S'enregistrer",
              style: TextStyle(
                fontSize: 24,
                color: Color(0xFF1A237E),
                fontWeight: FontWeight.bold,
              ),
            ),
            TextField(
              controller: nameTextEditingController,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "Nom",
                hintText: "Nom",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                // les styles
                hintStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 14,
                ),
              ),
            ),
            TextField(
              controller: emailTextEditingController,
              // champ de type email
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "Email",
                hintText: "Email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                // les styles
                hintStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 14,
                ),
              ),
            ),
            TextField(
              controller: phoneTextEditingController,
              // champ de type numero de telephone
              keyboardType: TextInputType.phone,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "Telephone",
                hintText: "Telephone",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                // les styles
                hintStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 14,
                ),
              ),
            ),
            TextField(
              controller: passwordTextEditingController,
              // champ de type text
              keyboardType: TextInputType.text,
              // masquer le mot de pass
              obscureText: true,
              style: const TextStyle(
                color: Colors.black,
              ),
              decoration: const InputDecoration(
                labelText: "Mot de pass",
                hintText: "Mot de pass",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF1A237E)),
                ),
                // les styles
                hintStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 10,
                ),
                labelStyle: TextStyle(
                  color: Color(0xFF1A237E),
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            ElevatedButton(
              onPressed: () {
                // clicker sur le boutton de 'Create Account' execute notre fonction (validate) declare plus haut
                validateForm();
              },
              // Style du boutton
              style: ElevatedButton.styleFrom(
                primary: const Color(0xFFF57F17),
              ),
              // Style du text du boutton
              child: const Text(
                "Creer un compte",
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 18,
                ),
              ),
            ),
            TextButton(
              child: const Text(
                "Deja un compte? Connectez vous",
                style: TextStyle(color: Color(0xFF1A237E)),
              ),
              onPressed: () {
                // clicker sur le boutton de 'Text' renvoie a notre ecran qui contient le formulaire de connection
                Navigator.push(context,
                    MaterialPageRoute(builder: (c) => const LoginScreen()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
