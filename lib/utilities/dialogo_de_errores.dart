import 'package:flutter/material.dart';

Future<void> mostraDialogoError(BuildContext context, String text,){
  return showDialog(context: context, builder:(context){
    return AlertDialog(
      title: const Text('ocurrio un error'),
      content: Text(text),
      actions: [
        TextButton(onPressed: (){
         Navigator.of(context).pop();
        }, child: const Text("OK"))
      ],
    );
  }
  
  );
}