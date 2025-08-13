import 'package:flutter/material.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DiogenesProfilePage(),
    ),
  );
}

class DiogenesProfilePage extends StatelessWidget {
  const DiogenesProfilePage({super.key});

  static const String _characterName = 'Diógenes';
  static const String _characterAge = '20 anos';
  static const String _profileImageUrl =
      'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRoraQe7AZBKjg1aE_c7Ib76zWirSdsj6ehlQ&s'; 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil de Diógenes'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ClipOval(
                child: Container(
                  width: 150,
                  height: 150,
                  color: Colors.grey[300],
                  child: Image.network(
                    _profileImageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (BuildContext context, Widget child,
                        ImageChunkEvent? loadingProgress) {
                      if (loadingProgress == null) {
                        return child;
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                    errorBuilder: (BuildContext context, Object exception,
                        StackTrace? stackTrace) {
                      return const Icon(Icons.person, size: 100, color: Colors.grey);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                _characterName,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                _characterAge,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const FavoriteMoviesPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.movie),
                  label: const Text('Filmes Favoritos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 250,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) =>
                            const FavoriteBooksPage(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.book),
                  label: const Text('Livros Favoritos'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueGrey[700],
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    textStyle: const TextStyle(fontSize: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class FavoriteMoviesPage extends StatelessWidget {
  const FavoriteMoviesPage({super.key});

  static const List<String> _favoriteMovies = <String>[
    'Branquelas',
    'Homem-Aranha',
    'Dragon Ball',
    'Como Treinar o Seu Dragão',
    'Vingadores',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmes Favoritos'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _favoriteMovies.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.local_play, color: Colors.blueGrey[700]),
              title: Text(
                _favoriteMovies[index],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          );
        },
      ),
    );
  }
}

class FavoriteBooksPage extends StatelessWidget {
  const FavoriteBooksPage({super.key});

  static const List<String> _favoriteBooks = <String>[
    'Rodrigo Porco Espinho',
    'Os Segredos da Mente Milionária',
    'O Homem Mais Rico da Babilônia',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Livros Favoritos'),
        backgroundColor: Colors.blueGrey[800],
        foregroundColor: Colors.white,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: _favoriteBooks.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            elevation: 4,
            child: ListTile(
              leading: Icon(Icons.menu_book, color: Colors.blueGrey[700]),
              title: Text(
                _favoriteBooks[index],
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            ),
          );
        },
      ),
    );
  }
}