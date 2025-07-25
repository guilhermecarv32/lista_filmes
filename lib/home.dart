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
  SortType _currentSort = SortType.byDateAdded;
  bool _isFilterPanelVisible = false;
  final _searchController = TextEditingController();
  

  @override
  void initState() {
    super.initState();
    // 1. ADICIONA O LISTENER
    // Esta função será chamada toda vez que o texto no campo de busca mudar.
    // O setState vazio força a reconstrução do widget para mostrar/esconder o ícone 'X'.
    _searchController.addListener(() {
      setState(() {});
    });
    _refreshFilmesList();
  }

  @override
  void dispose() {
    // É importante limpar o controller para liberar memória
    _searchController.dispose();
    super.dispose();
  }

  // --- ATUALIZADO: Agora passa o filtro, busca E ordenação para o banco ---
  void _refreshFilmesList() {
    setState(() {
      _filmesFuture = DatabaseHelper.instance.getFilmes(
        filter: _currentFilter,
        searchTerm: _searchController.text,
        sort: _currentSort, // Passa a ordenação atual
      );
    });
  }

  // --- ATUALIZADO: O painel agora inclui as opções de ordenação ---
  Widget _buildAnimatedFilterPanel() {
    const double panelHeight = 240.0; // Aumentamos a altura para caber tudo

    return AnimatedPositioned(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      top: _isFilterPanelVisible ? 0 : -panelHeight,
      left: 0,
      right: 0,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 300),
        opacity: _isFilterPanelVisible ? 1.0 : 0.0,
        child: Material(
          elevation: 4.0,
          child: Container(
            height: panelHeight,
            padding: const EdgeInsets.all(16.0),
            color: const Color(0xFF2d2f31),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Filtrar por:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0,
                  children: [
                    FilterChip(label: const Text('Todos'), selected: _currentFilter == FilterType.all, onSelected: (s) => _applyFilter(FilterType.all)),
                    FilterChip(label: const Text('Assistidos'), selected: _currentFilter == FilterType.watched, onSelected: (s) => _applyFilter(FilterType.watched)),
                    FilterChip(label: const Text('Não Assistidos'), selected: _currentFilter == FilterType.unwatched, onSelected: (s) => _applyFilter(FilterType.unwatched)),
                  ],
                ),
                const Divider(height: 24, color: Colors.white24),
                const Text('Ordenar por:', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                Wrap(
                  spacing: 8.0,
                  children: [
                    ChoiceChip(label: const Text('Data de Adição'), selected: _currentSort == SortType.byDateAdded, onSelected: (s) => _applySort(SortType.byDateAdded)),
                    ChoiceChip(label: const Text('Título (A-Z)'), selected: _currentSort == SortType.byTitleAZ, onSelected: (s) => _applySort(SortType.byTitleAZ)),
                    ChoiceChip(label: const Text('Ano (Mais Recente)'), selected: _currentSort == SortType.byYear, onSelected: (s) => _applySort(SortType.byYear)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _applyFilter(FilterType filter) {
    setState(() {
      _currentFilter = filter;
      // Não fechamos mais o painel aqui, para o usuário poder escolher a ordenação
    });
    _refreshFilmesList();
  }
  
  // --- NOVO: Função para aplicar a ordenação ---
  void _applySort(SortType sort) {
    setState(() {
      _currentSort = sort;
    });
    _refreshFilmesList();
  }

  void _toggleFilterPanel() {
    setState(() {
      _isFilterPanelVisible = !_isFilterPanelVisible;
    });
  }

  // --- WIDGET NOVO: BARRA DE PESQUISA ---
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchController,
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
                // 2. ADICIONA O ÍCONE DE LIMPAR (X)
                // Ele só aparece se o campo de texto não estiver vazio
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white70),
                        onPressed: () {
                          // 3. AÇÃO DE LIMPEZA
                          _searchController.clear(); // Limpa o texto
                          _refreshFilmesList();      // Atualiza a lista
                        },
                      )
                    : null, // Se estiver vazio, não mostra nada
              ),
              style: const TextStyle(color: Colors.white),
              onSubmitted: (_) => _refreshFilmesList(),
            ),
          ),
          const SizedBox(width: 10),
          Material(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.0),
            child: IconButton(
              icon: const Icon(Icons.send, color: Colors.white70),
              onPressed: _refreshFilmesList,
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
              onPressed: _toggleFilterPanel, // Chama a função de toggle
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
      body: Stack(
        children: [
          // CAMADA 1: Conteúdo Principal (pesquisa e lista)
          Column(
            children: [
              _buildSearchBar(), // Seu widget de barra de pesquisa
              Expanded(
                child: RefreshIndicator(
                // 2. A cor do ícone de carregamento
                color: const Color(0xFFE7801A),
                backgroundColor: const Color(0xFF2d2f31),
                // 3. A ação que será executada ao puxar
                onRefresh: () async {
                  // Apenas chamamos nossa função de recarregar a lista
                  _refreshFilmesList();
                  // Precisamos esperar o Future ser completado
                  await _filmesFuture;
                },
                child: FutureBuilder<List<Filme>>(
                  future: _filmesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting && snapshot.data == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return _buildEmptyState();
                    }
                    return _buildMoviesList(snapshot.data!);
                  },
                ),
              ),
            ),
          ],
        ),

           // --- NOVO: CAMADA 2: Fundo semitransparente ("Backdrop") ---
          // Aparece quando o painel de filtro está visível para dar foco e permitir o fechamento
          if (_isFilterPanelVisible)
            GestureDetector(
              onTap: _toggleFilterPanel, // Tocar no fundo fecha o painel
              child: Container(
                color: Colors.black.withOpacity(0.5),
              ),
            ),

          // CAMADA 3: O painel de filtros animado
          IgnorePointer(
            // 'ignoring' será 'true' quando o painel NÃO estiver visível
            ignoring: !_isFilterPanelVisible,
            child: _buildAnimatedFilterPanel(),
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