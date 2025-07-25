// lib/pages/home_page.dart

import 'package:flutter/material.dart';
import 'adicionar.dart';
import 'editar.dart';
import 'helpers/database_helper.dart';
import 'models/filme.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // CORREÇÃO 1: A lista de filmes foi movida para DENTRO da classe de estado.
  late Future<List<Filme>> _filmesFuture;
  FilterType _currentFilter = FilterType.all;

  @override
  void initState() {
    super.initState();
    _refreshFilmesList(); // Carrega os filmes ao iniciar a tela
  }

  // Função para (re)carregar a lista de filmes do banco de dados
  void _refreshFilmesList() {
    setState(() {
      _filmesFuture = DatabaseHelper.instance.getFilmes(filter: _currentFilter);
    });
  }

  // --- NOVO: Função que constrói e exibe o menu de filtros ---
  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF2d2f31), // Cor de fundo do menu
      builder: (context) {
        // Usamos um StatefulBuilder para que possamos atualizar o estado dos botões DENTRO do menu
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap( // Wrap permite que os botões quebrem a linha se não couberem
                spacing: 8.0,
                children: [
                  FilterChip(
                    label: const Text('Todos'),
                    selected: _currentFilter == FilterType.all,
                    onSelected: (selected) {
                      setModalState(() { _currentFilter = FilterType.all; });
                      _refreshFilmesList();
                      Navigator.pop(context); // Fecha o menu
                    },
                  ),
                  FilterChip(
                    label: const Text('Assistidos'),
                    selected: _currentFilter == FilterType.watched,
                    onSelected: (selected) {
                      setModalState(() { _currentFilter = FilterType.watched; });
                      _refreshFilmesList();
                      Navigator.pop(context);
                    },
                  ),
                  FilterChip(
                    label: const Text('Não Assistidos'),
                    selected: _currentFilter == FilterType.unwatched,
                    onSelected: (selected) {
                      setModalState(() { _currentFilter = FilterType.unwatched; });
                      _refreshFilmesList();
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

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
          // --- ATUALIZADO: Botão de Filtro agora chama a função do menu ---
          Material(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white70),
              onPressed: _showFilterSheet, // Chama a nova função
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

  // --- FUNÇÃO ATUALIZADA PARA CONSTRUIR A LISTA COM BORDA E SELO DE CHECK ---
  Widget _buildMoviesList(List<Filme> filmes) {
    return ListView.builder(
      padding: const EdgeInsets.all(12.0),
      itemCount: filmes.length,
      itemBuilder: (context, index) {
        final filme = filmes[index];
        return Card(
          color: Colors.white.withOpacity(0.1),
          elevation: 0,
          // 1. A BORDA VOLTOU!
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
            // Adiciona a borda lateral se o filme foi assistido
            side: filme.isWatched
                ? const BorderSide(color: Colors.green, width: 2.0)
                : BorderSide.none,
          ),
          margin: const EdgeInsets.symmetric(vertical: 8.0),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12.0),
            
            // 2. O SELO DE CHECK CONTINUA AQUI!
            leading: Stack(
              clipBehavior: Clip.none,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: filme.isWatched 
                      ? Colors.green 
                      : const Color(0xFFE7801A),
                  child: const Icon(Icons.movie, color: Colors.white),
                ),
                if (filme.isWatched)
                  Positioned(
                    bottom: -2,
                    right: -2,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Color(0xFF1B1C1D),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            
            // O resto do ListTile continua o mesmo
            title: Text(
              filme.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(filme.year, style: const TextStyle(color: Colors.white70)),
            trailing: IconButton(
              iconSize: 33.0,
              icon: Icon(
                filme.isWatched ? Icons.toggle_on : Icons.toggle_off_outlined,
                color: Colors.white70,
              ),
              onPressed: () async { // 1. A função agora é async
                    // 2. Cria uma cópia do filme com o status trocado
                    final filmeAtualizado = filme.copyWith(isWatched: !filme.isWatched);
                    // 3. Pede ao banco de dados para salvar a alteração
                    await DatabaseHelper.instance.updateFilme(filmeAtualizado);
                    // 4. Recarrega a lista da tela para mostrar a mudança
                    _refreshFilmesList();
                  },
              tooltip: 'Marcar como assistido',
            ),
            onTap: () {
              _navigateAndEditMovie(filme);
            },
          ),
        );
      },
    );
  }

  // FUNÇÃO PARA NAVEGAR E ADICIONAR UM FILME
  void _navigateAndAddMovie() async {
    final novoFilmeSemId = await Navigator.push<Filme>(context, MaterialPageRoute(builder: (context) => const AddMoviePage()));
    if (novoFilmeSemId != null) {
      await DatabaseHelper.instance.addFilme(novoFilmeSemId);
      _refreshFilmesList(); // Recarrega a lista do banco
    }
  }

  // 2. NOVA FUNÇÃO PARA NAVEGAR E EDITAR
  void _navigateAndEditMovie(Filme filme) async {
    // A chamada para a EditMoviePage agora pode retornar dois tipos de dados:
    // um objeto Filme (se editou) ou uma String (se excluiu)
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditMoviePage(filme: filme)),
    );

    // Verifica o tipo de resultado que voltou
    if (result != null) {
      if (result == 'delete') {
        // Se o resultado for a string 'delete', exclua o filme
        await DatabaseHelper.instance.deleteFilme(filme.id!);
      } else if (result is Filme) {
        // Se for um objeto Filme, atualize-o
        await DatabaseHelper.instance.updateFilme(result);
      }
      
      // Em ambos os casos (exclusão ou edição), recarregue a lista
      _refreshFilmesList();
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
            child: FutureBuilder<List<Filme>>(
              future: _filmesFuture,
              builder: (context, snapshot) {
                // Enquanto os dados estão carregando, mostre um spinner
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Se não houver dados ou a lista estiver vazia, mostre a tela de vazio
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return _buildEmptyState();
                }
                // Se houver dados, construa a lista
                return _buildMoviesList(snapshot.data!);
              },
            ),
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