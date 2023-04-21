
import 'package:itadministrador/servicios/autenticacion/auth_proveedor.dart';
import 'package:itadministrador/servicios/autenticacion/auth_usuario.dart';
import 'package:itadministrador/servicios/autenticacion/firebase_auth_provider.dart';

class AuthServicio implements AuthProveedor{
  final AuthProveedor proveedor;
 const  AuthServicio(this.proveedor);
  
 factory AuthServicio.firebase() => AuthServicio(FirebaseAuthProvider());

  @override
  Future<AuthUsuario?> crearUsuario({
    required String email, required String password}) =>
   proveedor.crearUsuario(email: email, password: password);
  
  
  @override

  AuthUsuario? get currentUser => proveedor.currentUser;
  
  @override
  Future<void> enviarEmailDeVerificacion() =>
  proveedor.enviarEmailDeVerificacion();
  
  @override
  Future<AuthUsuario?> logIn(
    {required String email, required String password}) => 
    proveedor.logIn(email: email, password: password);
  
  @override
  Future<void> logOut() =>
    proveedor.logOut();
    
 @override
 Future<void> initialize()  => proveedor.initialize();
  

} 