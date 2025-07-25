// lib/models/filme.dart

class Filme {
  final String title;
  final String year;
  final bool isWatched; // 1. NOVA PROPRIEDADE

  Filme({
    required this.title,
    required this.year,
    this.isWatched = false, // 2. VALOR PADRÃO: false
  });

  // 3. MÉTODO AUXILIAR 'copyWith' (MUITO ÚTIL!)
  // Cria uma cópia do filme, permitindo alterar apenas o que for necessário.
  Filme copyWith({
    String? title,
    String? year,
    bool? isWatched,
  }) {
    return Filme(
      title: title ?? this.title,
      year: year ?? this.year,
      isWatched: isWatched ?? this.isWatched,
    );
  }
}