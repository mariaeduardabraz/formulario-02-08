import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Formulário Flutter',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const TelaFormulario(),
    );
  }
}

class TelaFormulario extends StatefulWidget {
  const TelaFormulario({super.key});

  @override
  State<TelaFormulario> createState() => _TelaFormularioState();
}

class _TelaFormularioState extends State<TelaFormulario> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nomeController = TextEditingController();
  DateTime? _dataNascimento;
  String? _sexoSelecionado;

  // Função para abrir o seletor de data
  Future<void> _selecionarData(BuildContext context) async {
    final DateTime? selecionada = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (selecionada != null) {
      setState(() {
        _dataNascimento = selecionada;
      });
    }
  }

  bool _maiorDeIdade(DateTime data) {
    final hoje = DateTime.now();
    final idade = hoje.year - data.year;
    if (hoje.month < data.month ||
        (hoje.month == data.month && hoje.day < data.day)) {
      return idade - 1 >= 18;
    }
    return idade >= 18;
  }

  void _enviarFormulario() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cadastro de Usuário')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Nome Completo
              TextFormField(
                controller: _nomeController,
                decoration: const InputDecoration(labelText: 'Nome Completo'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe o nome completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Data de Nascimento
              InkWell(
                onTap: () => _selecionarData(context),
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Data de Nascimento',
                  ),
                  child: Text(
                    _dataNascimento == null
                        ? 'Selecione uma data'
                        : "${_dataNascimento!.day}/${_dataNascimento!.month}/${_dataNascimento!.year}",
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Sexo
              DropdownButtonFormField<String>(
                value: _sexoSelecionado,
                decoration: const InputDecoration(labelText: 'Sexo'),
                items: const [
                  DropdownMenuItem(value: 'Homem', child: Text('Homem')),
                  DropdownMenuItem(value: 'Mulher', child: Text('Mulher')),
                ],
                onChanged: (value) {
                  setState(() {
                    _sexoSelecionado = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Selecione o sexo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Botão de envio
              ElevatedButton(
                onPressed: () {
                  if (_dataNascimento == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Selecione uma data de nascimento'),
                      ),
                    );
                    return;
                  }

                  if (!_maiorDeIdade(_dataNascimento!)) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Cadastro permitido apenas para maiores de 18 anos.',
                        ),
                      ),
                    );
                    return;
                  }

                  _enviarFormulario();
                },
                child: const Text('Cadastrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
