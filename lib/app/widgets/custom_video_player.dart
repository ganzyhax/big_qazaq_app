import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';
import 'package:http/http.dart' as http;

class VideoPlayerWidget extends StatefulWidget {
  final Function(bool d) onFullScreenChange;

  final String url;

  VideoPlayerWidget({
    Key? key,
    required this.url,
    required this.onFullScreenChange,
  });

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  List<Map<String, String>>? _qualities;
  String? _currentUrl;
  String? _currentQuantity;

  late VideoPlayerController _controller;
  Future<void>? _initializeVideoPlayerFuture;
  double _volume = 1;
  int currentDurationInSecond = 0;
  bool isPaused = true;
  bool isFullScreen = false;
  bool showController = true;

  @override
  void initState() {
    super.initState();
    _initializeAsync();
  }

  Future<void> _initializeAsync() async {
    await _loadQualities();
    if (_qualities != null && _qualities!.isNotEmpty) {
      _currentUrl = _qualities!.last['url'];
      _currentQuantity = _qualities!.last['resolution'];
      setState(() {
        _initializeVideoPlayerFuture = _initializePlayer();
      });
    }
  }

  Future<void> _loadQualities() async {
    final qualities = await parseM3U8(widget.url);
    setState(() {
      _qualities = qualities;
    });
  }

  Future<List<Map<String, String>>> parseM3U8(String url) async {
    final response = await http.get(Uri.parse(url));
    final lines = response.body.split('\n');
    final qualities = <Map<String, String>>[];
    final seenResolutions = <String>{}; // Set to track seen resolutions

    for (int i = 0; i < lines.length; i++) {
      if (lines[i].contains('#EXT-X-STREAM-INF')) {
        final resolutionMatch =
            RegExp(r'RESOLUTION=\d+x(\d+)').firstMatch(lines[i]);
        final resolution = resolutionMatch?.group(1) ?? '480';
        final qualityUrl = lines[i + 1].trim();

        // Check if resolution or URL is already seen
        if (!seenResolutions.contains(resolution)) {
          qualities.add({'resolution': resolution, 'url': qualityUrl});
          seenResolutions.add(resolution); // Mark resolution as seen
        }
      }
    }
    return qualities;
  }

  Future<void> _initializePlayer() async {
    log(_currentUrl.toString());
    _controller = VideoPlayerController.network(widget.url!);
    await _controller.initialize();
    _controller.setLooping(true);
    _controller.setVolume(_volume);
    _controller.addListener(() {
      setState(() {
        currentDurationInSecond = _controller.value.position.inSeconds;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }

  void pause() {
    setState(() {
      isPaused = true;
      _controller.pause();
    });
  }

  void play() {
    setState(() {
      isPaused = false;
      _controller.play();
    });
  }

  void _setVolume(double volume) {
    setState(() {
      _volume = volume;
      _controller.setVolume(volume);
    });
  }

  void _seekToPosition(double seconds) {
    _controller.seekTo(Duration(seconds: seconds.toInt()));
  }

  void _toggleFullScreen() {
    setState(() {
      isFullScreen = !isFullScreen;
      widget.onFullScreenChange(
        isFullScreen,
      );

      if (isFullScreen) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ]);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showController = !showController;
        });
      },
      child: _initializeVideoPlayerFuture == null
          ? Container(
              height: isFullScreen
                  ? MediaQuery.of(context).size.height
                  : 250, // Fixed height in non-full-screen mode
              width: MediaQuery.of(context).size.width,
            )
          : FutureBuilder<void>(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    children: [
                      Container(
                        height: isFullScreen
                            ? MediaQuery.of(context).size.height
                            : 250, // Fixed height in non-full-screen mode
                        width: MediaQuery.of(context).size.width,
                        color: Colors
                            .black, // Ensure black background in full screen
                        child: Stack(
                          children: [
                            Center(
                              child: AspectRatio(
                                aspectRatio: _controller.value.aspectRatio,
                                child: VideoPlayer(_controller),
                              ),
                            ),
                            if (_controller.value.isBuffering)
                              Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                ),
                              ),
                            Positioned(
                              bottom: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                padding: (!isFullScreen)
                                    ? EdgeInsets.only(left: 4, right: 4)
                                    : EdgeInsets.only(left: 19, right: 19),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Column(
                                  children: [
                                    if (showController)
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (isPaused) {
                                                    play();
                                                  } else {
                                                    pause();
                                                  }
                                                },
                                                child: Icon(
                                                  isPaused
                                                      ? Icons.play_arrow
                                                      : Icons.pause,
                                                  color: Colors.white,
                                                  size: 24,
                                                ),
                                              ),
                                              SizedBox(width: 3),
                                              GestureDetector(
                                                onTap: () {
                                                  _setVolume(
                                                      _volume == 0 ? 1 : 0);
                                                },
                                                child: Icon(
                                                  _volume != 0
                                                      ? Icons.volume_up
                                                      : Icons.volume_off,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                              ),
                                              if (_qualities != null &&
                                                  _qualities!.isNotEmpty)
                                                Container(
                                                  width: 70,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15),
                                                  ),
                                                  child:
                                                      PopupMenuButton<String>(
                                                    icon: Text(
                                                      _currentQuantity
                                                              .toString() +
                                                          'p',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          color: Colors.white),
                                                    ),
                                                    onSelected: (String value) {
                                                      setState(() {
                                                        _controller.dispose();
                                                        isPaused = true;
                                                        showController = true;
                                                        _currentUrl = _qualities!
                                                            .firstWhere((quality) =>
                                                                quality[
                                                                    'resolution'] ==
                                                                value)['url'];
                                                        _currentQuantity =
                                                            _qualities!.firstWhere(
                                                                    (quality) =>
                                                                        quality[
                                                                            'resolution'] ==
                                                                        value)[
                                                                'resolution'];
                                                        _initializeVideoPlayerFuture =
                                                            _initializePlayer(); // Re-initialize with the new URL
                                                      });
                                                    },
                                                    itemBuilder:
                                                        (BuildContext context) {
                                                      return _qualities!
                                                          .map((quality) {
                                                        return PopupMenuItem<
                                                            String>(
                                                          value: quality[
                                                              'resolution']!,
                                                          child: Text(
                                                            "${quality['resolution']}p",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        );
                                                      }).toList();
                                                    },
                                                  ),
                                                ),
                                              SizedBox(width: 3),
                                              Text(
                                                '${formatDuration(Duration(seconds: currentDurationInSecond))} / ${formatDuration(_controller.value.duration)}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            height: 35,
                                            width: (isFullScreen)
                                                ? MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.69
                                                : MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.4,
                                            child: SliderTheme(
                                              data: SliderTheme.of(context)
                                                  .copyWith(
                                                thumbShape: RoundSliderThumbShape(
                                                    enabledThumbRadius:
                                                        7.0), // Adjust dot size here
                                                overlayShape:
                                                    RoundSliderOverlayShape(
                                                        overlayRadius: 1.0),
                                                trackHeight: 4.0,
                                              ),
                                              child: Slider(
                                                value: currentDurationInSecond
                                                    .toDouble(),
                                                max: _controller
                                                    .value.duration.inSeconds
                                                    .toDouble(),
                                                onChanged: _seekToPosition,
                                                activeColor: Colors.white,
                                                inactiveColor: Colors.grey,
                                              ),
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: _toggleFullScreen,
                                            child: Icon(
                                              isFullScreen
                                                  ? Icons.fullscreen_exit
                                                  : Icons.fullscreen,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                } else {
                  return Center(
                    child: Container(
                      color: Colors.black,
                      height: isFullScreen
                          ? MediaQuery.of(context).size.height
                          : 250, // Fixed height in non-full-screen mode
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
    );
  }
}
