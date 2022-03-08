import 'dart:js';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MessageToast 
{
  late FToast fToast;

// @override
// void initState() {
//     super.initState();
//     fToast = FToast();
//     fToast.init(context);
// }
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
            // prend en paramettre "massage"
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
}