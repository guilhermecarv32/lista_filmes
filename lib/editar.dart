// lib/pages/editar.dart

import 'package:flutter/material.dart';
import 'models/filme.dart';

class EditMoviePage extends StatefulWidget {
  // 1. RECEBE O FILME A SER EDITADO
  final Filme filme;

  const EditMoviePage({super.key, required this.filme});

  @override
  State<EditMoviePage> createState() => _EditMoviePageState();
}

class _EditMoviePageState extends State<EditMoviePage> {
  final _titleController = TextEditingController();
  final _yearController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late bool _isWatched;

  @override
  void initState() {
    super.initState();
    // 2. PREENCHE OS CAMPOS COM OS DADOS DO FILME
    _titleController.text = widget.filme.title;
    _yearController.text = widget.filme.year;
    _isWatched = widget.filme.isWatched;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  // A função _buildTextField é exatamente a mesma
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),

        prefixIcon: Icon(
          icon, color: Colors.white70
          ),
        filled: true,
        fillColor: Colors.white.withOpacity(0.1),

        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), 
          borderSide: BorderSide.none
          ),

        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: const BorderSide(
            color: Color(0xFFE7801A)
            )
          ),

        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), 
          borderSide: const BorderSide(
            color: Colors.redAccent
            )
          ),

        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0), 
          borderSide: const BorderSide(
            color: Colors.redAccent, width: 2
            )
          ),
      ),
      style: const TextStyle(color: Colors.white),
    );
  }
  
  void _showDeleteConfirmationDialog() async { // 1. A função agora é async
    // 2. Esperamos o resultado do diálogo
    final result = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1B1C1D),
          title: const Text('Confirmar Exclusão', style: TextStyle(color: Colors.white)),
          content: const Text('Tem certeza de que deseja excluir este filme? Esta ação não pode ser desfeita.', style: TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar', style: TextStyle(color: Colors.white70)),
              onPressed: () {
                Navigator.of(context).pop(); // Apenas fecha o diálogo, sem resultado
              },
            ),
            TextButton(
              child: const Text('Excluir', style: TextStyle(color: Colors.redAccent)),
              onPressed: () {
                // Fecha o diálogo e retorna o resultado 'delete'
                Navigator.of(context).pop('delete'); 
              },
            ),
          ],
        );
      },
    );

    // 3. Se o resultado for 'delete', aí sim fechamos a tela de edição
    if (result == 'delete') {
      // Usamos um segundo Navigator.pop para fechar a EditMoviePage e enviar 
      // o sinal 'delete' de volta para a HomePage.
      // O 'mounted' checa se o widget ainda está na tela, uma boa prática.
      if (mounted) {
        Navigator.of(context).pop('delete');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C1D),
      appBar: AppBar(
        // 3. TÍTULO ATUALIZADO
        title: const Text('Editar Filme'),
        backgroundColor: const Color(0xFF1B1C1D),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
            onPressed: _showDeleteConfirmationDialog,
            tooltip: 'Excluir Filme',
          ),
        ],
      ),
      body: SingleChildScrollView(
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
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'O título é obrigatório.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _yearController,
                labelText: 'Ano de Lançamento',
                icon: Icons.calendar_today,
                keyboardType: TextInputType.number,
              ),

              const SizedBox(height: 20),
              SwitchListTile(
                title: const Text('Assistido?', style: TextStyle(color: Colors.white)),
                value: _isWatched,
                onChanged: (bool value) {
                  setState(() {
                    _isWatched = value;
                  });
                },
                activeColor: const Color(0xFFE7801A),
                tileColor: Colors.white.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),

              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    // ATUALIZA O OBJETO USANDO O NOVO VALOR DE _isWatched
                    final filmeAtualizado = Filme(
                      id: widget.filme.id, // <-- A LINHA CRUCIAL QUE FALTAVA
                      title: _titleController.text,
                      year: _yearController.text,
                      isWatched: _isWatched,
                    );
                    Navigator.pop(context, filmeAtualizado);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE7801A),
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                ),
                // 5. TEXTO DO BOTÃO ATUALIZADO
                child: const Text('Salvar Alterações', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}