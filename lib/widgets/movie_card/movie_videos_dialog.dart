import 'package:flutter/material.dart';
import 'package:movie_notes/models/movie.dart';
import 'package:movie_notes/models/movie_video.dart';
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
    child: FutureBuilder<List<MovieVideo>>(
      future: AppScope.of(
        context,
      ).mediaRepository.getMediaVideos(widget.movie.id, widget.movie.type),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: CircularProgressIndicator());
        }

        final videos = snapshot.data ?? [];

        if (videos.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
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
          _createController(videos[0].key);
        }

        return Container(
          child: _controller == null
              ? const Center(child: CircularProgressIndicator())
              : YoutubePlayer(controller: _controller!),
        );
      },
    ),
  );
}
