import 'package:flutter/material.dart';
import 'video_data.dart'; // استيراد تعريف VideoData

class MostViewsPage extends StatelessWidget {
  final List<VideoData> videos;

  MostViewsPage({Key? key, required this.videos}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sortedVideos = List<VideoData>.from(videos);
    sortedVideos.sort((a, b) => b.durationWatched.compareTo(a.durationWatched));

    return Scaffold(
      appBar: AppBar(
        title: Text("Most Viewed Videos"),
      ),
      body: ListView.builder(
        itemCount: sortedVideos.length,
        itemBuilder: (context, index) {
          final video = sortedVideos[index];
          final duration = video.durationWatched;

          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
              child: Icon(Icons.play_arrow, color: Colors.white),
            ),
            title: Text(video.title),
            subtitle: Text(
              "Category: ${video.category} • Duration: ${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}",
            ),
            trailing: Icon(Icons.visibility),
          );
        },
      ),
    );
  }
}
