import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import 'most_views.dart';
import 'video_data.dart';
import 'task_activity.dart';

class ReelsPage extends StatefulWidget {
  @override
  _ReelsPageState createState() => _ReelsPageState();
}

class _ReelsPageState extends State<ReelsPage> {
  final List<VideoData> _videos = [
    VideoData(path: 'assets/videos/minecraft.mp4', category: 'minecraft'),
    VideoData(path: 'assets/videos/jimawi.mp4', category: 'jimawi'),
    VideoData(path: 'assets/videos/mokhbir.mp4', category: 'mokhbir'),
    VideoData(path: 'assets/videos/animals.mp4', category: 'animals'),
    VideoData(path: 'assets/videos/cafe.mp4', category: 'cafe'),
    VideoData(path: 'assets/videos/forest.mp4', category: 'forest'),
    VideoData(path: 'assets/videos/flowers.mp4', category: 'flowers'),
    VideoData(path: 'assets/videos/sea.mp4', category: 'sea'),
  ];

  PageController _pageController = PageController();
  List<VideoPlayerController> _controllers = [];
  bool _showControls = false;

  int _currentVideoIndex = 0;
  DateTime? _videoStartTime;
  Duration _totalWatchTime = Duration.zero;
  bool _popupShown = false;

  @override
  void initState() {
    super.initState();
    for (var video in _videos) {
      final controller = VideoPlayerController.asset(video.path)
        ..initialize().then((_) => setState(() {}))
        ..setLooping(true);
      _controllers.add(controller);
    }
    WakelockPlus.enable();
    _controllers.first.play();
    _videoStartTime = DateTime.now();
  }

  @override
  void dispose() {
    final now = DateTime.now();
    if (_videoStartTime != null && _currentVideoIndex < _videos.length) {
      final watchedDuration = now.difference(_videoStartTime!);
      _updateVideoDuration(watchedDuration);
    }

    for (var controller in _controllers) {
      controller.dispose();
    }
    WakelockPlus.disable();
    _pageController.dispose();
    super.dispose();
  }

  void _updateVideoDuration(Duration watchedDuration) {
    final oldVideo = _videos[_currentVideoIndex];
    _videos[_currentVideoIndex] = VideoData(
      path: oldVideo.path,
      category: oldVideo.category,
      durationWatched: oldVideo.durationWatched + watchedDuration,
    );
    _totalWatchTime += watchedDuration;
    _checkForPopup();
  }

  void _onPageChanged(int index) {
    final now = DateTime.now();

    if (_videoStartTime != null && _currentVideoIndex < _videos.length) {
      final watchedDuration = now.difference(_videoStartTime!);
      _updateVideoDuration(watchedDuration);
    }

    _currentVideoIndex = index;
    _videoStartTime = now;

    for (int i = 0; i < _controllers.length; i++) {
      if (i == index) {
        _controllers[i].play();
      } else {
        _controllers[i].pause();
      }
    }

    setState(() {
      _showControls = false;
    });
  }

  void _checkForPopup() {
    if (_totalWatchTime.inSeconds >= 10 && !_popupShown) {
      _popupShown = true;

      showGeneralDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.black.withOpacity(0.6),
        transitionDuration: Duration(milliseconds: 300),
        pageBuilder: (_, __, ___) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Image of a person (replace with your asset path)
                    Image.asset(
                      'assets/images/ic_kids_logo.png',
                      height: 250,
                    ),
                    SizedBox(height: 30),
                    // Arabic message
                    Text(
                      'دعنا نذهب لإكمال مهمتك اليومية',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                    ),
                    SizedBox(height: 40),
                    // Button to navigate
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // close dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => TaskActivity()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.yellow,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                            horizontal: 40, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        textStyle: TextStyle(
                          fontSize: 22,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text('هيا بنا'),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    }
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });

    if (_showControls) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          setState(() => _showControls = false);
        }
      });
    }
  }

  Widget _buildVideoPlayer(VideoPlayerController controller) {
    return GestureDetector(
      onTap: _toggleControls,
      child: Stack(
        fit: StackFit.expand,
        children: [
          controller.value.isInitialized
              ? FittedBox(
            fit: BoxFit.cover,
            child: SizedBox(
              width: controller.value.size.width,
              height: controller.value.size.height,
              child: VideoPlayer(controller),
            ),
          )
              : Center(child: CircularProgressIndicator()),

          if (_showControls)
            Center(
              child: IconButton(
                iconSize: 72,
                icon: Icon(
                  controller.value.isPlaying
                      ? Icons.pause_circle_filled
                      : Icons.play_circle_fill,
                  color: Colors.white,
                ),
                onPressed: () {
                  setState(() {
                    controller.value.isPlaying
                        ? controller.pause()
                        : controller.play();
                  });
                },
              ),
            ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: controller.value.isInitialized
                ? VideoProgressIndicator(
              controller,
              allowScrubbing: true,
              padding: EdgeInsets.zero,
              colors: VideoProgressColors(
                playedColor: Colors.redAccent,
                bufferedColor: Colors.white30,
                backgroundColor: Colors.black26,
              ),
            )
                : SizedBox.shrink(),
          ),

          Positioned(
            bottom: 80,
            left: 16,
            right: 16,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.favorite_border, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.comment, color: Colors.white),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.share, color: Colors.white),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo2.png',
              height: 80,
              width: 80,
            ),
            SizedBox(width: 8),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.bar_chart, color: Colors.black),
            tooltip: "Most Viewed",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MostViewsPage(videos: _videos),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.check_circle, color: Colors.black),
            tooltip: "Task Activity",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TaskActivity()),
              );
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: _videos.length,
        onPageChanged: _onPageChanged,
        itemBuilder: (context, index) =>
            _buildVideoPlayer(_controllers[index]),
      ),
    );
  }
}
