import 'package:flutter/material.dart';

var myDefaultBackground = Colors.grey[300];

var myAppBar = AppBar(
 backgroundColor: Colors.grey[900],
);

var myDrawer = Drawer(
        child: Column(children: const [
          DrawerHeader(child: Image(image: AssetImage('lib/assets/imagenes/UNICAH_logo.png')),),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('P R I N C I P A L'),
          ),
          ListTile(
            leading: Icon(Icons.computer_rounded),
            title: Text('E Q U I P O S'),
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('B U S C A R'),
          ),
          ListTile(
            leading: Icon(Icons.bookmark_add),
            title: Text('A G R E G A R'),
          ),
        ]),
      );
      
