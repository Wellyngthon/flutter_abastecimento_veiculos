import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


class EditarVeiculoTela extends StatefulWidget {
  final String id;
  final Map<String, dynamic> dados;

  EditarVeiculoTela({required this.id, required this.dados});

  @override
  _EditarVeiculoTelaState createState() => _EditarVeiculoTelaState();
}

class _EditarVeiculoTelaState extends State<EditarVeiculoTela> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _modeloController;
  late TextEditingController _marcaController;
  late TextEditingController _placaController;
  late TextEditingController _anoController;
  late TextEditingController _tipoCombustivelController;

  @override
  void initState() {
    super.initState();
    _modeloController = TextEditingController(text: widget.dados['modelo']);
    _marcaController = TextEditingController(text: widget.dados['marca']);
    _placaController = TextEditingController(text: widget.dados['placa']);
    _anoController = TextEditingController(text: widget.dados['ano']);
    _tipoCombustivelController = TextEditingController(text: widget.dados['tipoCombustivel']);
  }

  Future<void> _atualizarVeiculo() async {
    if (_formKey.currentState!.validate()) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance
          .collection('veiculos')
          .doc(uid)
          .collection('lista')
          .doc(widget.id)
          .update({
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
      appBar: AppBar(title: Text('Editar Veículo')),
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
                onPressed: _atualizarVeiculo,
                child: Text('Atualizar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}