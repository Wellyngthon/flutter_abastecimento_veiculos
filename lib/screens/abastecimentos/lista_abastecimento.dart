import 'package:abastecimento_veiculos/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cadastro_abastecimento.dart';

class ListaAbastecimentosTela extends StatelessWidget {
  final String veiculoId;

  ListaAbastecimentosTela({required this.veiculoId});

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final abastecimentosCollection = FirebaseFirestore.instance
        .collection('veiculos')
        .doc(uid)
        .collection('lista')
        .doc(veiculoId)
        .collection('abastecimentos');

    final abastecimentosQuery = abastecimentosCollection.orderBy('data', descending: true);

    return Scaffold(
      appBar: AppBar(title: Text('Abastecimentos')),
      drawer: AppDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: abastecimentosQuery.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Erro ao carregar dados'));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text('Nenhum abastecimento registrado'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final id = doc.id;
              final dataFormatada = DateTime.parse(data['data']);

              return ListTile(
                title: Text('R\$ ${data['valorPago'].toStringAsFixed(2)} - ${data['quantidadeLitros']} L'),
                subtitle: Text(
                  'Data: ${dataFormatada.day}/${dataFormatada.month}/${dataFormatada.year} | KM: ${data['quilometragem']} | Consumo: ${data['consumo'].toStringAsFixed(2)} km/L',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.edit),
                      tooltip: 'Editar abastecimento',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CadastroAbastecimentoTela(
                              veiculoId: veiculoId,
                              abastecimentoId: id,
                              dados: data,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: 'Excluir abastecimento',
                      onPressed: () {
                        abastecimentosCollection.doc(id).delete();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CadastroAbastecimentoTela(veiculoId: veiculoId),
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Registrar novo abastecimento',
      ),
    );
  }
}