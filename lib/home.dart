// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'adicionar.dart';

// Por enquanto, vamos usar um 'dynamic' para a lista de filmes.
// Em breve, vamos criar uma classe 'Filme' para organizar melhor.
final List<dynamic> _listaDeFilmes = [];

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // --- WIDGET NOVO: BARRA DE PESQUISA ---
  // Este widget constrói a barra de pesquisa e os botões.
  Widget _buildSearchBar() {
    return Padding(
      // Adiciona um espaçamento nas laterais e no topo.
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: Row(
        children: [
          // Campo de texto expansível
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

          // Botão de Pesquisar
          Material(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white70),
              onPressed: () {
                print('Botão de pesquisar pressionado!');
              },
              tooltip: 'Pesquisar',
            ),
          ),
          const SizedBox(width: 8),

          // Botão de Filtro
          Material(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white70),
              onPressed: () {
                print('Botão de filtro pressionado!');
              },
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
          Icon(
            Icons.video_library,
            size: 80,
            color: Colors.white.withOpacity(0.6),
          ),
          const SizedBox(height: 16),
          Text(
            'Sua lista está vazia.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              color: Colors.white.withOpacity(0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Toque em + para adicionar um filme.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.4),
            ),
          ),
        ],
      ),
    );
  }

  // Widget que será exibido quando houver filmes na lista.
  Widget _buildMoviesList() {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 12.0), // Espaçamento para não colar na barra de pesquisa
      itemCount: _listaDeFilmes.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(_listaDeFilmes[index].toString()),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1B1C1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE7801A),
        centerTitle: true,
        title: const Text(
          'Meus Filmes',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      
      // --- ALTERAÇÃO PRINCIPAL AQUI ---
      // O body agora é uma Column para empilhar os widgets verticalmente.
      body: Column(
        children: [
          // 1. A barra de pesquisa é o primeiro item.
          _buildSearchBar(),
          
          // 2. O conteúdo principal (lista ou mensagem) ocupa o resto do espaço.
          Expanded(
            child: _listaDeFilmes.isEmpty 
                ? _buildEmptyState() 
                : _buildMoviesList(),
          ),
        ],
      ),
      
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // 2. ALTERE A AÇÃO DO BOTÃO
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddMoviePage()),
          );
        },
        backgroundColor: const Color(0xFFE7801A),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}