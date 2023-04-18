import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:flutter/foundation.dart';


@immutable
class AuthUsuario {
  final bool esEmailVerificado;

 const AuthUsuario(this.esEmailVerificado);
factory AuthUsuario.fromFirebase(User usuario) => AuthUsuario(usuario.emailVerified);
}


