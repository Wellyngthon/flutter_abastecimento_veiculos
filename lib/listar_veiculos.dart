import 'package:abastecimento_veiculos/editar_veiculo.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'cadastro_veiculos.dart';
import 'lista_abastecimento.dart';

class ListaVeiculosTela extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final veiculosRef = FirebaseFirestore.instance.collection('veiculos').doc(uid).collection('lista');

    return Scaffold(
      appBar: AppBar(title: Text('Meus Veículos')),
      body: StreamBuilder<QuerySnapshot>(
        stream: veiculosRef.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) return Center(child: Text('Erro ao carregar veículos'));
          if (snapshot.connectionState == ConnectionState.waiting) return Center(child: CircularProgressIndicator());

          final docs = snapshot.data!.docs;

          if (docs.isEmpty) return Center(child: Text('Nenhum veículo cadastrado'));

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text('${data['modelo']} (${data['ano']})'),
                subtitle: Text('Marca: ${data['marca']} - Placa: ${data['placa']} - Combustível: ${data['tipoCombustivel']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.local_gas_station),
                      tooltip: 'Ver abastecimentos',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ListaAbastecimentosTela(veiculoId: doc.id),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.edit),
                      tooltip: 'Editar veículo',
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => EditarVeiculoTela(
                              id: doc.id,
                              dados: data,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      tooltip: 'Excluir veículo',
                      onPressed: () {
                        veiculosRef.doc(doc.id).delete();
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
          Navigator.push(context, MaterialPageRoute(builder: (_) => CadastroVeiculoTela()));
        },
        child: Icon(Icons.add),
        tooltip: 'Cadastrar novo veículo',
      ),
    );
  }
}