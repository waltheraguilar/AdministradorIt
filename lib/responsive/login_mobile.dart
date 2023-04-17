
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
   late final TextEditingController _email;
  late final TextEditingController _password;
  @override
  void initState() {
    // TODO: implement initState
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
   

  @override
  Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(title: const Text('Login'),),
        body: Column(
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: "Ingresa Tu Correo",
                  ),
                ),
                TextField(
                  controller: _password,
                  obscureText: true,
                  enableSuggestions: false,
                  autocorrect: false,
                  decoration: const InputDecoration(
                    hintText: "Ingresa Tu Contraseña",
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final email = _email.text;
                    final password = _password.text;
                  try {
                     final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);
                    print(userCredential);
                    
                  } on FirebaseAuthException catch(a){//verificamos si el error es de firebase autenticacion
                      if (a.code =='user-not-found') {
                        print('user not found');
                      }else if(a.code=='wrong-password'){
                          print("Wrong Password");
                        print(a.code);
      
                      }
      
                  }catch (e) {
                    
                   print(e);
                    print(e.runtimeType);
                  }
                   
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed:(){
                  Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
                  },
                  child:const Text("Not Registered YET? Register Here!"),
                ),
              ],
            ),
      );
  }


}