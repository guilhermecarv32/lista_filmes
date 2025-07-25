// lib/pages/add_movie_page.dart

import 'package:flutter/material.dart';

class AddMoviePage extends StatefulWidget {
  const AddMoviePage({super.key});

  @override
  State<AddMoviePage> createState() => _AddMoviePageState();
}

class _AddMoviePageState extends State<AddMoviePage> {
  // Controladores para pegar o texto dos campos
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _posterUrlController = TextEditingController();

  // Chave para o formulário, útil para validação futura
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Limpar os controladores quando a tela for fechada para liberar memória
    _titleController.dispose();
    _yearController.dispose();
    _posterUrlController.dispose();
    super.dispose();
  }

  // Função para criar os campos de texto com estilo padronizado
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
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
      ),
      style: const TextStyle(color: Colors.white),
      // Adicionaremos validação aqui no futuro
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C1D),
      appBar: AppBar(
        // O Flutter adiciona o botão de voltar automaticamente
        title: const Text('Adicionar Filme'),
        backgroundColor: const Color(0xFF1B1C1D), // Mesma cor do fundo
        elevation: 0, // Sem sombra na appbar
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        // Permite rolar a tela se o teclado cobrir os campos
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 20),
              _buildTextField(
                controller: _titleController,
                labelText: 'Título',
                icon: Icons.title,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _yearController,
                labelText: 'Ano de Lançamento',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _posterUrlController,
                labelText: 'URL do Pôster',
                icon: Icons.link,
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  // Lógica para salvar o filme virá aqui
                  final title = _titleController.text;
                  final year = _yearController.text;
                  print('Salvando filme: $title ($year)');
                  // Fechar a tela após salvar
                  Navigator.pop(context);
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