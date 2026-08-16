import 'package:material_ui/material_ui.dart';
import 'package:movie_match/l10n/app_localizations.dart';
import 'package:movie_match/models/movie.dart';
import 'package:movie_match/widgets/app_scope.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieVideoScreen extends StatefulWidget {
  const MovieVideoScreen({required this.movie, super.key});

  final Movie movie;

  @override
  State<MovieVideoScreen> createState() => _MovieVideoScreenState();
}

class _MovieVideoScreenState extends State<MovieVideoScreen> {
  YoutubePlayerController? _controller;
  bool isRotated = false;
  bool _loading = true;
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_loaded) return;
    _loaded = true;

    _loadVideo();
  }

  Future<void> _loadVideo() async {
    final videoId = await AppScope.of(
      context,
    ).mediaRepository.getTrailerKey(widget.movie.id, widget.movie.type);

    if (!mounted) return;

    if (videoId == null) {
      setState(() => _loading = false);
      return;
    }

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      autoPlay: true,
      params: const YoutubePlayerParams(
        showControls: true,
        showVideoAnnotations: false,
        enableCaption: false,
        strictRelatedVideos: true,
      ),
    );

    setState(() => _loading = false);
  }

  void _rotateScreen() {
    setState(() => isRotated = !isRotated);
  }

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(AppLocalizations.of(context)!.trailer_title),
      actions: [
        IconButton(
          onPressed: _rotateScreen,
          icon: const Icon(Icons.screen_rotation),
        ),
      ],
      actionsPadding: const .only(right: 8),
    ),
    body: _loading
        ? const Center(child: CircularProgressIndicator())
        : _controller == null
        ? Center(
            child: Text(
              AppLocalizations.of(context)!.no_available_videos,
              textAlign: .center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          )
        : Center(
            child: RotatedBox(
              quarterTurns: isRotated ? 1 : 0,
              child: YoutubePlayer(controller: _controller!),
            ),
          ),
  );
}
