import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:vriddhi_0/constants.dart';
import 'package:vriddhi_0/screens/current_screen.dart';
import 'package:vriddhi_0/screens/registration_screen.dart';
import 'package:vriddhi_0/services/Authentication.dart';

class LoginScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: kPrimaryAppbarColor,
        leadingWidth: 80,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
      ),
      body: LoginForm(),
    );
  }
}

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormBuilderState> _formKey = GlobalKey <FormBuilderState>();
  late String email;
  late String password;
  final _auth = FirebaseAuth.instance;
  bool showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child:Column(
          children: [
            FormBuilder(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Login",
                          style: kFormPrimaryHeadingStyle,
                        ),
                        Text(
                          "Fill your account details",
                          style: kFormSecondaryHeadingStyle,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10.0),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                      name: 'email',
                      onChanged: (value) {
                        email = value!;
                      },
                      decoration: kFormLabelTextFieldStyle.copyWith(labelText: "Email", hintText: "Enter your email-id"),
                      validator: FormBuilderValidators.compose([
                        FormBuilderValidators.required(),
                        FormBuilderValidators.email(),
                      ]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FormBuilderTextField(
                        name: 'password',
                        onChanged: (value) {
                          password = value!;
                        },
                        decoration: kFormLabelTextFieldStyle.copyWith(labelText: "Password", hintText: "Enter your password"),
                        obscureText: true,
                        validator: FormBuilderValidators.compose([FormBuilderValidators.required(), FormBuilderValidators.minLength(8)])
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height:36.0,
                  width:158.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      try{
                        setState(() {
                          showSpinner = true;
                        });
                        final user = await _auth.signInWithEmailAndPassword(email: email, password: password);
                        if(user != null){
                          Navigator.pushReplacementNamed(context, '/current_bottom_navbar');
                        }
                        setState(() {
                          showSpinner = false;
                        });
                      }catch(e){
                        print(e);
                      }

                    },
                    child: Text('Login'),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontFamily: "Catamaran",
                      ),
                      backgroundColor: kButtonPositiveColor,
                    ),
                  ),
                ),
                SizedBox(height: 20.0,),
                Text(
                    "OR"
                ),
                SizedBox(height: 20.0,),
                SizedBox(
                  height:60.0,
                  width:258.0,
                  child: ElevatedButton(
                    onPressed: (){} ,
                    child: ListView(
                      children: [
                        GestureDetector(
                          onTap: (){
                            Authentication.signInWithGoogle(context: context);
                          },
                          child: ListTile(
                            leading: Icon(FontAwesomeIcons.google, color: kButtonPositiveColor,),
                            title: Text("Sign In with Google", style: TextStyle(color: kButtonPositiveColor,fontSize: 15.0)),
                          ),
                        ),
                      ],
                    ),
                    style: ElevatedButton.styleFrom(
                      textStyle: TextStyle(
                        fontFamily: "Catamaran",
                      ),
                      backgroundColor: kBackgroundColor,
                    ),
                  ),
                ),
                SizedBox(height:40.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account ? ", style: TextStyle(color: kButtonPositiveColor, fontSize: 16.0),),
                    RichText(text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Register Here !",
                          style: TextStyle(color: kPrimaryGreenColor, fontSize: 16.0),
                          recognizer: TapGestureRecognizer()
                            ..onTap = (){Navigator.pushNamed(context, '/registeration');},
                        ),
                      ],
                    ),),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

