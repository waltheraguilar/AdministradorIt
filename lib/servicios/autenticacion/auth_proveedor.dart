import 'package:itadministrador/servicios/autenticacion/auth_usuario.dart';

abstract class AuthProveedor{

  Future<void> initialize();
  AuthUsuario? get currentUser;

  Future<AuthUsuario?> logIn({
   required String email,
   required String password,

  });

Future<AuthUsuario?> crearUsuario({
   required String email,
   required String password,
   
  });

  Future<void> logOut();
  Future<void> enviarEmailDeVerificacion();
  
}