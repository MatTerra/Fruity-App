import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fruity/pages/all_species_page.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    ByteData data =
        await PlatformAssetBundle().load('assets/ca/lets-encrypt-r3.pem');
    SecurityContext.defaultContext
        .setTrustedCertificatesBytes(data.buffer.asUint8List());
  }
  // await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final providers = [EmailAuthProvider()];

    return MaterialApp(
      title: "Fruity",
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      locale: const Locale("pt", "BR"),
      initialRoute: FirebaseAuth.instance.currentUser == null ? '/sign-in' : '/home',
      routes: {
        '/sign-in': (context) {
          return SignInScreen(
            providers: providers,
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Image.asset('assets/manga.png'),
                ),
              );
            },
            actions: [
              ForgotPasswordAction((context, email) {
                Navigator.pushNamed(
                  context,
                  '/forgot-password',
                  arguments: {'email': email},
                );
              }),
              AuthStateChangeAction<SignedIn>((context, state) {
                if (!state.user!.emailVerified) {
                  state.user!.sendEmailVerification();
                  Navigator.pushNamed(context, '/verify-email');
                } else {
                  Navigator.pushNamedAndRemoveUntil(context, '/home', (r)=>false);
                }
              }),
            ],
            styles: const {
              EmailFormStyle(signInButtonVariant: ButtonVariant.filled),
            },
            subtitleBuilder: (context, action) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  action == AuthAction.signIn
                      ? 'Bem vindo ao Fruity! Faça login para continuar.'
                      : 'Bem vindo ao Fruity! Se cadastre para continuar.',
                ),
              );
            },
            footerBuilder: (context, action) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Text(
                    action == AuthAction.signIn
                        ? 'Ao logar, você concorda com nossos termos e condições.'
                        : 'Ao se registrar, você concorda com nossos termos e condições.',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ),
              );
            },
          );
        },
        '/verify-email': (context) {
          return EmailVerificationScreen(
            // headerBuilder: headerIcon(Icons.verified),
            // sideBuilder: sideIcon(Icons.verified),
            // actionCodeSettings: actionCodeSettings,
            actions: [
              EmailVerifiedAction(() {
                Navigator.pushReplacementNamed(context, '/profile');
              }),
              AuthCancelledAction((context) {
                FirebaseUIAuth.signOut(context: context);
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
          );
        },
        '/forgot-password': (context) {
          final arguments = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;

          return ForgotPasswordScreen(
            email: arguments?['email'],
            headerMaxExtent: 200,
            // headerBuilder: headerIcon(Icons.lock),
            // sideBuilder: sideIcon(Icons.lock),
          );
        },
        '/profile': (context) {
          return ProfileScreen(
            actions: [
              SignedOutAction((context) {
                Navigator.pushReplacementNamed(context, '/sign-in');
              }),
            ],
            // actionCodeSettings: actionCodeSettings,
          );
        },
        '/home': (context) {
          return AllSpeciesPage();
        }
      },
    );
  }
}
