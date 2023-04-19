import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';


@immutable
class AuthUsuario {
  final String id;
  final String email;
  final bool isEmailVerified;

 const AuthUsuario({
  required this.id,
  required this.email ,
  required this.isEmailVerified});
factory AuthUsuario.fromFirebase(User usuario) => AuthUsuario(
   id:usuario.uid,
  email: usuario.email!,
 isEmailVerified: usuario.emailVerified);
}


