import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_cast_member.dart';
import 'package:movie_notes/widgets/app_scope.dart';

class MovieCastScreen extends StatelessWidget {
  const MovieCastScreen({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final repository = AppScope.of(context).mediaRepository;

    return Scaffold(
      appBar: AppBar(title: const Text('Актёрский состав')),
      body: FutureBuilder<List<MovieCastMember>>(
        future: repository.getMediaCredits(movie.id, movie.type),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Не удалось загрузить список актёров.'),
            );
          }

          final cast = snapshot.data ?? [];

          if (cast.isEmpty) {
            return const Center(child: Text('Актёры не найдены.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: cast.length,
            itemBuilder: (context, index) {
              final member = cast[index];
              final profileUrl = member.profilePath;

              return ListTile(
                contentPadding: const EdgeInsets.all(0),
                leading: CircleAvatar(
                  radius: 30,
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  backgroundImage: profileUrl != null && profileUrl.isNotEmpty
                      ? NetworkImage(
                          'https://image.tmdb.org/t/p/w185$profileUrl',
                        )
                      : null,
                  child: profileUrl == null || profileUrl.isEmpty
                      ? const Icon(Icons.person)
                      : null,
                ),
                title: Text(member.name),
                subtitle: member.character.isNotEmpty
                    ? Text(member.character)
                    : const Text('Роль неизвестна'),
              );
            },
          );
        },
      ),
    );
  }
}
