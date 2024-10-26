import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fruity/pages/all_species_page.dart';
import 'package:fruity/pages/tree_map_page.dart';

class FruityDrawer extends StatelessWidget {
  const FruityDrawer({
    super.key,
    required this.user,
    required this.role,
  });

  final User? user;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.green),
            child: Column(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/profile');
                    },
                    child: UserAvatar(
                      auth: FirebaseAuth.instance,
                    ),
                  ),
                ),
                Text(user?.displayName ?? user?.email ?? '')
              ],
            ),
          ),
          ListTile(
            title: const Text('Espécies'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllSpeciesPage(pending: false)));
            },
          ),
          ListTile(
            title: const Text('Minhas espécies'),
            onTap: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AllSpeciesPage(
                            pending: false,
                            mine: true,
                          )));
            },
          ),
          role == 'admin'
              ? ListTile(
                  title: const Text('Espécies pendentes'),
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AllSpeciesPage(
                                  pending: true,
                                )));
                  },
                )
              : Container(),
          ListTile(
            title: const Text('Mapa de Árvores'),
            onTap: () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => TreeMapPage()));
            },
          )
        ],
      ),
    );
  }
}
