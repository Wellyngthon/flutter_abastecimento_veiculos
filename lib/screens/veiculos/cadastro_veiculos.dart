import 'package:abastecimento_veiculos/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroVeiculoTela extends StatefulWidget {
  @override
  _CadastroVeiculoTelaState createState() => _CadastroVeiculoTelaState();
}

class _CadastroVeiculoTelaState extends State<CadastroVeiculoTela> {
  final _formKey = GlobalKey<FormState>();
  final _modeloController = TextEditingController();
  final _marcaController = TextEditingController();
  final _placaController = TextEditingController();
  final _anoController = TextEditingController();
  final _tipoCombustivelController = TextEditingController();

  Future<void> _salvarVeiculo() async {
    if (_formKey.currentState!.validate()) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('veiculos')
          .doc(uid)
          .collection('lista')
          .add({
        'modelo': _modeloController.text.trim(),
        'marca': _marcaController.text.trim(),
        'placa': _placaController.text.trim(),
        'ano': _anoController.text.trim(),
        'tipoCombustivel': _tipoCombustivelController.text.trim(),
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cadastrar Veículo')),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _modeloController,
                decoration: InputDecoration(labelText: 'Modelo'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o modelo' : null,
              ),
              TextFormField(
                controller: _marcaController,
                decoration: InputDecoration(labelText: 'Marca'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a marca' : null,
              ),
              TextFormField(
                controller: _placaController,
                decoration: InputDecoration(labelText: 'Placa'),
                validator: (value) => value == null || value.isEmpty ? 'Informe a placa' : null,
              ),
              TextFormField(
                controller: _anoController,
                decoration: InputDecoration(labelText: 'Ano'),
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty ? 'Informe o ano' : null,
              ),
              TextFormField(
                controller: _tipoCombustivelController,
                decoration: InputDecoration(labelText: 'Tipo de Combustível'),
                validator: (value) => value == null || value.isEmpty ? 'Informe o tipo de combustível' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvarVeiculo,
                child: Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}