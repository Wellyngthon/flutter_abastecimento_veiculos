import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CadastroAbastecimentoTela extends StatefulWidget {
  final String veiculoId;
  final String? abastecimentoId;
  final Map<String, dynamic>? dados;

  CadastroAbastecimentoTela({
    required this.veiculoId,
    this.abastecimentoId,
    this.dados,
  });

  @override
  _CadastroAbastecimentoTelaState createState() => _CadastroAbastecimentoTelaState();
}

class _CadastroAbastecimentoTelaState extends State<CadastroAbastecimentoTela> {
  final _formKey = GlobalKey<FormState>();
  final _litrosController = TextEditingController();
  final _valorController = TextEditingController();
  final _kmController = TextEditingController();
  final _tipoCombustivelController = TextEditingController();
  final _obsController = TextEditingController();
  late DateTime _data;

  @override
  void initState() {
    super.initState();
    if (widget.dados != null) {
      final dados = widget.dados!;
      _litrosController.text = dados['quantidadeLitros'].toString();
      _valorController.text = dados['valorPago'].toString();
      _kmController.text = dados['quilometragem'].toString();
      _tipoCombustivelController.text = dados['tipoCombustivel'];
      _obsController.text = dados['observacao'];
      _data = DateTime.parse(dados['data']);
    } else {
      _data = DateTime.now();
    }
  }

  Future<void> _salvar() async {
    if (_formKey.currentState!.validate()) {
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final litros = double.parse(_litrosController.text);
      final km = int.parse(_kmController.text);
      final consumo = litros > 0 ? km / litros : 0;

      final dados = {
        'data': _data.toIso8601String(),
        'quantidadeLitros': litros,
        'valorPago': double.parse(_valorController.text),
        'quilometragem': km,
        'tipoCombustivel': _tipoCombustivelController.text.trim(),
        'veiculoId': widget.veiculoId,
        'consumo': consumo,
        'observacao': _obsController.text.trim(),
      };

      final docRef = FirebaseFirestore.instance
          .collection('veiculos')
          .doc(uid)
          .collection('lista')
          .doc(widget.veiculoId)
          .collection('abastecimentos');

      if (widget.abastecimentoId != null) {
        await docRef.doc(widget.abastecimentoId).update(dados);
      } else {
        await docRef.add(dados);
      }

      Navigator.pop(context);
    }
  }

  String? _valida(String? value) => value == null || value.isEmpty ? 'Campo obrigatório' : null;

  @override
  Widget build(BuildContext context) {
    final isEdicao = widget.abastecimentoId != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdicao ? 'Editar Abastecimento' : 'Novo Abastecimento')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Text('Data: ${_data.day}/${_data.month}/${_data.year}'),
              TextFormField(
                controller: _litrosController,
                decoration: InputDecoration(labelText: 'Quantidade de Litros'),
                keyboardType: TextInputType.number,
                validator: _valida,
              ),
              TextFormField(
                controller: _valorController,
                decoration: InputDecoration(labelText: 'Valor Pago'),
                keyboardType: TextInputType.number,
                validator: _valida,
              ),
              TextFormField(
                controller: _kmController,
                decoration: InputDecoration(labelText: 'Quilometragem'),
                keyboardType: TextInputType.number,
                validator: _valida,
              ),
              TextFormField(
                controller: _tipoCombustivelController,
                decoration: InputDecoration(labelText: 'Tipo de Combustível'),
                validator: _valida,
              ),
              TextFormField(
                controller: _obsController,
                decoration: InputDecoration(labelText: 'Observação'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _salvar,
                child: Text(isEdicao ? 'Atualizar' : 'Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}