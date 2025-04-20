import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnu_web_dashboard/camera/util/cctv_manager.dart';
import 'package:gnu_web_dashboard/common/const/color.dart';
import 'package:gnu_web_dashboard/common/const/style.dart';

import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

class RtspPlayer extends StatefulWidget {
  final double width;
  final double minWidth;
  final double fontSize;
  final String roomId;

  RtspPlayer({
    super.key,
    required this.roomId,
    required this.width,
    required this.minWidth,
    this.fontSize = 16,
  });

  @override
  State<RtspPlayer> createState() => _RtspPlayerState();
}

class _RtspPlayerState extends State<RtspPlayer> {
  bool isPlaying = false;
  Timer? _timer;

  final Player player = Player();
  late final VideoController controller;

  final CctvManager cctv = CctvManager(serverIp: 'http://117.16.154.97:8083');


  @override
  void initState() {
    controller = VideoController(player);
    super.initState();
  }


  void startRtsp(String roomId) {
    final address = cctv.getHlsAddress(roomId);

    isPlaying = true;
    player.open(Media(address), play: true);
    _timer = Timer(Duration(seconds: 32), () {
      setState(() {
        stopRtsp();
      });
    });
  }

  void stopRtsp() {
    player.stop();
    _timer?.cancel();
    isPlaying = false;
  }

  @override
  void dispose() {
    stopRtsp();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isPlaying) {
            stopRtsp();
          } else {
            startRtsp(widget.roomId);
          }
        });
      },
      child: Container(
        width: widget.width,
        constraints: BoxConstraints(maxHeight: 600, minWidth: widget.minWidth),
        decoration: BoxDecoration(
          color: PRIMARY_CONTAINER_COLOR,
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child:
              isPlaying
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(16.0),
                    child: IgnorePointer(
                      child: Video(controller: controller, fit: BoxFit.cover),
                    ),
                  )
                  : Center(
                    child: Text(
                      '클릭하여 강의실 카메라 보기\n(30초)',
                      textAlign: TextAlign.center,
                      style: TERTIARY_TITLE_TEXT_STYLE.copyWith(
                        fontSize: widget.fontSize,
                        color: WHITE_TEXT_COLOR,
                      ),
                    ),
                  ),
        ),
      ),
    );
  }
}
