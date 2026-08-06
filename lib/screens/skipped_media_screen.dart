import 'package:flutter/material.dart';
import 'package:movie_notes/widgets/app_scope.dart';

class SkippedMediaScreen extends StatelessWidget {
  const SkippedMediaScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final repository = AppScope.of(context).skippedMediaRepository;

    return Scaffold(
      appBar: AppBar(title: const Text('Пропущенные')),
      body: FutureBuilder(
        future: repository.getSkippedMedia(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == .waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          final items = snapshot.data ?? const [];

          if (items.isEmpty) {
            return const Center(child: Text('Список пропущенных фильмов пуст'));
          }

          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final movie = items[index];
              return Dismissible(
                key: ValueKey(movie.id),
                background: Container(
                  color: Colors.grey,
                  alignment: .centerRight,
                  padding: const .symmetric(horizontal: 20),
                  child: const Row(
                    mainAxisAlignment: .end,
                    children: [
                      Icon(Icons.undo, color: Colors.white),
                      SizedBox(width: 8),
                      Text('Вернуть', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                direction: .endToStart,
                onDismissed: (_) => repository.removeSkippedMedia(movie.id),
                child: ListTile(
                  title: Text(movie.title),
                  trailing: const Icon(
                    Icons.swipe_left,
                    size: 18,
                    color: Colors.grey,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
