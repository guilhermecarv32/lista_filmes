// lib/pages/add_movie_page.dart

import 'package:flutter/material.dart';

class AddMoviePage extends StatefulWidget {
  const AddMoviePage({super.key});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();

  // Chave para o formulário, agora será usada para validação.
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    // NOVO: Adicionamos um parâmetro opcional para o validador
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      // NOVO: Atribuímos o validador ao campo de texto
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Color(0xFFE7801A)),
        ),
        // Estilo para a mensagem de erro
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
        ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C1D),
      appBar: AppBar(
        title: const Text('Adicionar Filme'),
        backgroundColor: const Color(0xFF1B1C1D),
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              // Campo de Título com o validador
              _buildTextField(
                controller: _titleController,
                labelText: 'Título',
                icon: Icons.title,
                // NOVO: Lógica de validação para o título
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O título é obrigatório.';
                  }
                  return null; // Retornar null significa que o campo é válido
                },
              ),
              const SizedBox(height: 20),
              // Outros campos não têm validador, pois não são obrigatórios
              _buildTextField(
                controller: _yearController,
                labelText: 'Ano de Lançamento',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // NOVO: Adicionamos a verificação do formulário
                  // O '!' garante ao Dart que _formKey.currentState não será nulo aqui.
                  if (_formKey.currentState!.validate()) {
                    // Se o formulário for válido, execute o código de salvar.
                    final title = _titleController.text;
                    final year = _yearController.text;
                    print('Formulário válido! Salvando filme: $title ($year)');
                    
                    // Fecha a tela após salvar
                    Navigator.pop(context);
                  } else {
                    // Se o formulário for inválido, a mensagem de erro já apareceu na tela.
                    print('Formulário inválido!');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7801A),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text(
                  'Salvar Filme',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}