import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/repositories/skipped_media_repository.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:movie_notes/widgets/dialogs/confirmation_dialog.dart';

class SkippedMediaScreen extends StatefulWidget {
  const SkippedMediaScreen({super.key});

  @override
  State<SkippedMediaScreen> createState() => _SkippedMediaScreenState();
}

class _SkippedMediaScreenState extends State<SkippedMediaScreen> {
  late final SkippedMediaRepository _repository;

  List<Movie> _items = [];
  bool _isLoading = true;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_initialized) {
      _initialized = true;
      _repository = AppScope.of(context).skippedMediaRepository;

      _loadItems();
    }
  }

  Future<void> _loadItems() async {
    final items = await _repository.getSkippedMedia();

    if (!mounted) return;

    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  Future<void> _removeMovie(int movieId) async {
    await _repository.removeSkippedMedia(movieId);
    if (!mounted) return;
    setState(() => _items.removeWhere((item) => item.id == movieId));
  }

  Future<void> _restoreAllMovies() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => const ConfirmationDialog(
        title: 'Вернуть все фильмы?',
        content: 'Все пропущенные фильмы будут возвращены в каталог.',
        confirmText: 'Вернуть',
      ),
    );

    if (confirmed != true) return;

    await _repository.restoreAllSkippedMedia();

    if (!mounted) return;

    setState(() => _items.clear());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text('Пропущенные'),
      actions: [
        if (_items.isNotEmpty)
          IconButton(
            onPressed: _restoreAllMovies,
            icon: const Icon(Icons.restore),
            tooltip: 'Вернуть все',
          ),
      ],
      actionsPadding: const EdgeInsets.only(right: 8),
    ),
    body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : _items.isEmpty
        ? const Center(child: Text('Список пропущенных фильмов пуст'))
        : ListView.builder(
            itemCount: _items.length,
            itemBuilder: (context, index) {
              final movie = _items[index];

              return Dismissible(
                key: ValueKey(movie.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  color: Colors.grey,
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: const Row(
                    spacing: 8,
                    mainAxisAlignment: .end,
                    children: [
                      Icon(Icons.undo, color: Colors.white),
                      Text('Вернуть', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
                onDismissed: (_) => _removeMovie(movie.id),
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
          ),
  );
}
