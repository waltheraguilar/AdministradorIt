
import 'package:flutter/material.dart';
import 'package:itadministrador/responsive/responsive.dart';

import 'responsive/desktop_scaffold.dart';
import 'responsive/mobile_scaffold.dart';
import 'responsive/tablet_scaffold.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
 const MyApp({Key? key}) : super(key: key);

 @override

 Widget build(BuildContext context){
  return  MaterialApp(
    debugShowCheckedModeBanner: false,
    home:ResponsiveLayout(
      desktopScaffold: const DesktopScaffold(),
       mobileScaffold: const MobileScaffold(),
        tabletScaffold: const TabletScaffold()
        ),
  );
 }
 

}