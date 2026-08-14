import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_notes/l10n/app_localizations.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class MovieVideoScreen extends StatefulWidget {
  const MovieVideoScreen({required this.movie, super.key});

  final Movie movie;

  @override
  State<MovieVideoScreen> createState() => _MovieVideoScreenState();
}

class _MovieVideoScreenState extends State<MovieVideoScreen> {
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _createController(String videoId) {
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
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(AppLocalizations.of(context)!.trailer_title)),
    body: FutureBuilder<String?>(
      future: AppScope.of(
        context,
      ).mediaRepository.getTrailerKey(widget.movie.id, widget.movie.type),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              AppLocalizations.of(context)!.no_available_videos,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          );
        }

        final trailerKey = snapshot.data;

        if (trailerKey == null) {
          return Center(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(16),
              child: Text(
                AppLocalizations.of(context)!.no_available_videos,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          );
        }

        if (_controller == null) {
          _createController(trailerKey);
          _controller!.enterFullScreen();

          SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ]);
          _controller!.setFullScreenListener((isFullScreen) {
            if (!isFullScreen) {
              SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
              SystemChrome.setPreferredOrientations([
                DeviceOrientation.portraitUp,
                DeviceOrientation.portraitDown,
              ]);
              Navigator.of(context).pop();
            }
          });
        }

        return YoutubePlayer(controller: _controller!);
      },
    ),
  );
}
