import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/widgets/app_scope.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';
import '../../l10n/app_localizations.dart';

class MovieVideosDialog extends StatefulWidget {
  const MovieVideosDialog({required this.movie, super.key});

  final Movie movie;

  @override
  State<MovieVideosDialog> createState() => _MovieVideosDialogState();
}

class _MovieVideosDialogState extends State<MovieVideosDialog> {
  YoutubePlayerController? _controller;

  @override
  void dispose() {
    _controller?.close();
    super.dispose();
  }

  void _createController(String videoId) {
    _controller?.close();

    _controller = YoutubePlayerController.fromVideoId(
      videoId: videoId,
      params: const YoutubePlayerParams(
        showControls: true,
        showVideoAnnotations: false,
        enableCaption: false,
        showFullscreenButton: true,
        strictRelatedVideos: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Dialog(
    backgroundColor: Colors.transparent,
    insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
    child: FutureBuilder<String?>(
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

        if (_controller == null) {
          _createController(trailerKey);
        }

        return YoutubePlayer(controller: _controller!);
      },
    ),
  );
}
