import 'package:abastecimento_veiculos/screens/auth/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'screens/veiculos/listar_veiculos.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            leading: Icon(Icons.directions_car),
            title: Text('Meus Veículos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ListaVeiculosTela()),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.add),
            title: Text('Registrar Abastecimento'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ListaVeiculosTela()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selecione um veículo para registrar o abastecimento')),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('Histórico de Abastecimentos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => ListaVeiculosTela()),
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Selecione um veículo para ver o histórico')),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Sair'),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => LoginTela()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}