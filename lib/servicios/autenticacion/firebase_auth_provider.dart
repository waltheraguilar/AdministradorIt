import 'package:firebase_core/firebase_core.dart';
import 'package:itadministrador/servicios/autenticacion/auth_usuario.dart';
import 'package:itadministrador/servicios/autenticacion/auth_proveedor.dart';
import 'package:itadministrador/servicios/autenticacion/auth_excepciones.dart';

import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth, FirebaseAuthException;

import '../../firebase_options.dart';

class FirebaseAuthProvider implements AuthProveedor {
  @override
  Future<AuthUsuario?> crearUsuario({
    required String email, required String password}) async {
    try {
      
    await   FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
         password: password);

         final usuario = currentUser;
         if (usuario != null) {
           return usuario;
         } else {
          throw UsuarioNoLogueadoAuthExcepcion();
         }

    } on FirebaseAuthException catch (e) {
      if (e.code=='weak-password') {
     throw ContrasenaDebilAuthExcepcion();
     } else if(e.code=='email-already-in-use'){
      throw EmailYaEstaEnUsoAuthExcepcion();                
      }else if(e.code=='invalid-email'){
      throw EmailInvalidoExcepcion();              
     } else {
      throw GenericaAuthExcepcion();
      }
                        
    } catch (_){
      throw GenericaAuthExcepcion();
    }
  }

  @override
  // TODO: implement currentUser
  AuthUsuario? get currentUser {
    final usuario = FirebaseAuth.instance.currentUser;
    if(usuario != null){
      return AuthUsuario.fromFirebase(usuario);
    } else {
      return null;
    }

  }

  @override
  Future<void> enviarEmailDeVerificacion() async {
    final usuario = FirebaseAuth.instance.currentUser;

    if(usuario != null){
      await usuario.sendEmailVerification();
    } else {
      throw UsuarioNoLogueadoAuthExcepcion();
    }
  }

  @override
  Future<AuthUsuario?> logIn(
    {required String email, required String password}) async {
    
    try {
      FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, 
        password: password);

       final usuario = currentUser;
         if (usuario != null) {
           return usuario;
         } else {
          throw UsuarioNoLogueadoAuthExcepcion();
         }
    } on FirebaseAuthException catch (a) {
     if (a.code == 'user-not-found') {
       throw UsuarioAuthNoEcontrado();           
    } else if (a.code == 'wrong-password') {
      throw MalaContrasenaAuthException();
    } else {
              throw GenericaAuthExcepcion(); 
                }
   } catch(_){
              throw GenericaAuthExcepcion();
              }
  }

  @override
  Future<void> logOut() async{
  final usuario = FirebaseAuth.instance.currentUser;
   if (usuario != null) {
           await FirebaseAuth.instance.signOut();
         } else {
          throw UsuarioNoLogueadoAuthExcepcion();
         }
  }
  
  @override
  Future<void> initialize() async{
    await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
  }

}