import 'package:abastecimento_veiculos/listar_veiculos.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:abastecimento_veiculos/cadastro.dart';

class LoginTela extends StatefulWidget {
  @override
  _LoginTelaState createState() => _LoginTelaState();
}

class _LoginTelaState extends State<LoginTela> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();

  bool _isLoading = false;

  Future<void> _realizarLogin() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _senhaController.text.trim(),
        );
        Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) => ListaVeiculosTela()),
);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login realizado com sucesso!')),
        );
      } on FirebaseAuthException catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${e.message}")),
        );
      } finally {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Gas Station App')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Image.asset('assets/gasStation.png', height: 150),
              SizedBox(height: 50),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Campo de email vazio";
                  }
                  if (!value.contains("@")) {
                    return "O email não é válido";
                  }
                  return null;
                },
                keyboardType: TextInputType.emailAddress,
              ),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: 'Senha'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "A senha não pode ser vazia";
                  }
                  if (value.length < 6) {
                    return "Senha muito curta";
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              _isLoading
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: _realizarLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightGreenAccent,
                      ),
                      child: Text('Entrar'),
                    ),
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CadastroTela()),
                  );
                },
                child: Text('Cadastre-se'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}