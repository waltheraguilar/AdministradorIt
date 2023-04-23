import 'package:flutter/material.dart';

import 'dilogo_generica.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context){
  return showGenericDialog(
    context: context,
     title: 'Compartir 📳',
      content: 'No puedes si los campos estan vacios 😿', 
      optionBuilder: () => {
        'ok':null,
      },
      );
}