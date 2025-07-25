// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'adicionar.dart'; // Mantive o nome 'adicionar.dart' que você está usando
import 'models/filme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // CORREÇÃO 1: A lista de filmes foi movida para DENTRO da classe de estado.
  final List<Filme> _listaDeFilmes = [];

  // --- WIDGET NOVO: BARRA DE PESQUISA ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Pesquisar...',
                hintStyle: TextStyle(color: Colors.white.withOpacity(0.5)),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                filled: true,
                fillColor: Colors.white.withOpacity(0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white70),
              onPressed: () { print('Botão de pesquisar pressionado!'); },
              tooltip: 'Pesquisar',
            ),
          ),
          const SizedBox(width: 8),
          Material(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white70),
              onPressed: () { print('Botão de filtro pressionado!'); },
              tooltip: 'Filtros',
            ),
          ),
        ],
      ),
    );
  }

  // Widget que será exibido quando a lista de filmes estiver vazia.
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library, size: 80, color: Colors.white.withOpacity(0.6)),
          const SizedBox(height: 16),
          Text('Sua lista está vazia.', textAlign: TextAlign.center, style: TextStyle(fontSize: 18, color: Colors.white.withOpacity(0.6))),
          const SizedBox(height: 8),
          Text('Toque em + para adicionar um filme.', textAlign: TextAlign.center, style: TextStyle(fontSize: 16, color: Colors.white.withOpacity(0.4))),
        ],
      ),
    );
  }

  // FUNÇÃO ATUALIZADA PARA CONSTRUIR A LISTA DE CARDS DE FILMES
  Widget _buildMoviesList() {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: _listaDeFilmes.length,
      itemBuilder: (context, index) {
        final filme = _listaDeFilmes[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            // Como não tem pôster, podemos usar um ícone no lugar
            leading: const CircleAvatar(
              backgroundColor: Color(0xFFE7801A),
              child: Icon(Icons.movie, color: Colors.white),
            ),
            title: Text(filme.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            subtitle: Text(filme.year, style: const TextStyle(color: Colors.white70)),
            onTap: () {},
          ),
        );
      },
    );
  }

  // FUNÇÃO PARA NAVEGAR E ADICIONAR UM FILME
  void _navigateAndAddMovie() async {
    final novoFilme = await Navigator.push<Filme>(
      context,
      MaterialPageRoute(builder: (context) => const AddMoviePage()),
    );

    if (novoFilme != null) {
      setState(() {
        _listaDeFilmes.add(novoFilme);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE7801A),
        centerTitle: true,
        title: const Text('Meus Filmes', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          Expanded(
            child: _listaDeFilmes.isEmpty
                ? _buildEmptyState()
                : _buildMoviesList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        // CORREÇÃO 2: Ação do botão agora chama a função correta.
        onPressed: _navigateAndAddMovie,
        backgroundColor: const Color(0xFFE7801A),
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}