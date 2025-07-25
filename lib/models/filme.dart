// lib/models/filme.dart

class Filme {
  int? id; // 1. ID ÚNICO DO BANCO DE DADOS (pode ser nulo se ainda não foi salvo)
  String title;
  String year;
  bool isWatched;

  Filme({
    this.id,
    required this.title,
    required this.year,
    this.isWatched = false,
  });

  // 2. CONVERTE UM OBJETO FILME EM UM MAP
  // O banco de dados armazena dados como 'Mapas'.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'year': year,
      // O SQLite não tem um tipo booleano, então salvamos 1 para true e 0 para false.
      'isWatched': isWatched ? 1 : 0,
    };
  }

  // 3. CONVERTE UM MAP EM UM OBJETO FILME
  // Útil quando lemos os dados do banco.
  factory Filme.fromMap(Map<String, dynamic> map) {
    return Filme(
      id: map['id'],
      title: map['title'],
      year: map['year'],
      isWatched: map['isWatched'] == 1,
    );
  }

  // O copyWith continua útil, agora com o id
  Filme copyWith({
    int? id,
    String? title,
    String? year,
    bool? isWatched,
  }) {
    return Filme(
      id: id ?? this.id,
      title: title ?? this.title,
      year: year ?? this.year,
      isWatched: isWatched ?? this.isWatched,
    );
  }
}