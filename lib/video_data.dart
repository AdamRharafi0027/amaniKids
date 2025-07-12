class VideoData {
  final String path;
  final String category;
  final String title;
  final Duration durationWatched;

  VideoData({
    required this.path,
    required this.category,
    Duration? durationWatched,
  })  : title = path.split('/').last.split('.').first,
        durationWatched = durationWatched ?? Duration.zero;
}
