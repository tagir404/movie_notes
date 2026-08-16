import 'package:material_ui/material_ui.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/models/movie_cast_member.dart';
import 'package:movie_match/widgets/app_scope.dart';
import '../l10n/app_localizations.dart';

class MovieCastScreen extends StatelessWidget {
  const MovieCastScreen({required this.movie, super.key});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final repository = AppScope.of(context).mediaRepository;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.movie_cast_title),
      ),
      body: FutureBuilder<List<MovieCastMember>>(
        future: repository.getMediaCredits(movie.id, movie.type),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.movie_cast_load_error),
            );
          }

          final cast = snapshot.data ?? [];

          if (cast.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.movie_cast_not_found),
            );
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
                title: member.name.isNotEmpty
                    ? Text(member.name)
                    : Text(AppLocalizations.of(context)!.unknown),
                subtitle: member.character.isNotEmpty
                    ? Text(member.character)
                    : Text(
                        AppLocalizations.of(context)!.movie_cast_unknown_role,
                      ),
              );
            },
          );
        },
      ),
    );
  }
}
