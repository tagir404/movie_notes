import 'package:material_ui/material_ui.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/services/ai_search_service.dart';
import 'package:movie_match/widgets/app_scope.dart';
import '../l10n/app_localizations.dart';

class AiSearchScreen extends StatefulWidget {
  const AiSearchScreen({super.key});

  @override
  State<AiSearchScreen> createState() => _AiSearchScreenState();
}

class _AiSearchScreenState extends State<AiSearchScreen> {
  final _controller = TextEditingController();

  late final AiSearchService _aiSearchService;
  bool _initialized = false;

  bool _isLoading = false;
  bool _hasSearched = false;
  bool _hasError = false;
  String _errorMessage = '';
  List<Movie> _results = const [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;
    _aiSearchService = AppScope.of(context).aiSearchService;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _search() async {
    final description = _controller.text.trim();
    if (description.isEmpty) return;

    setState(() {
      _isLoading = true;
      _hasSearched = true;
      _hasError = false;
      _errorMessage = '';
    });

    try {
      final results = await _aiSearchService.search(description: description);

      if (!mounted) return;

      setState(() {
        _results = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _hasError = true;
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.ai_search_title)),
      body: Column(
        children: [
          Padding(
            padding: const .all(16),
            child: Row(
              spacing: 8,
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    minLines: 1,
                    maxLines: 3,
                    textInputAction: .search,
                    onSubmitted: (_) => _search(),
                    decoration: InputDecoration(
                      hintText: l10n.ai_search_hint,
                      border: const OutlineInputBorder(),
                    ),
                  ),
                ),
                FilledButton(
                  onPressed: _isLoading ? null : _search,
                  child: _isLoading
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(l10n.ai_search_button),
                ),
              ],
            ),
          ),
          Expanded(child: _buildBody(l10n)),
        ],
      ),
    );
  }

  Widget _buildBody(AppLocalizations l10n) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_hasError) {
      return Center(
        child: Padding(
          padding: const .all(24),
          child: Text(
            _errorMessage.isNotEmpty ? _errorMessage : l10n.ai_search_error,
            textAlign: .center,
          ),
        ),
      );
    }

    if (!_hasSearched) {
      return Center(
        child: Padding(
          padding: const .all(24),
          child: Text(l10n.ai_search_empty, textAlign: .center),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(child: Text(l10n.ai_search_no_results));
    }

    return ListView.separated(
      padding: const .all(16),
      itemCount: _results.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => _MovieResultTile(movie: _results[index]),
    );
  }
}

class _MovieResultTile extends StatelessWidget {
  const _MovieResultTile({required this.movie});

  final Movie movie;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const .all(12),
        child: Row(
          crossAxisAlignment: .start,
          spacing: 12,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: movie.posterPath == null
                  ? Container(
                      width: 60,
                      height: 90,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.movie),
                    )
                  : Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      width: 60,
                      height: 90,
                      fit: BoxFit.cover,
                    ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(movie.title, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Text(
                    movie.overview,
                    style: theme.textTheme.bodySmall,
                    maxLines: 3,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
