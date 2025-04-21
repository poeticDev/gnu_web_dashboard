import 'package:gnu_web_dashboard/common/util/network/http_manager.dart';

class CctvManager {
  static CctvManager? _instance;

  final String _serverIp;

  CctvManager._internal(this._serverIp);

  factory CctvManager({required String serverIp}) {
    if (serverIp.endsWith('/')) {
      serverIp = serverIp.substring(0, serverIp.length - 1);
    }
    return _instance ??= CctvManager._internal(serverIp);
  }

  String get serverIp => _serverIp;

  final HttpManager _http = HttpManager();

  static Map<String, String> _roomIdHlsAddressMap = {
    // streamId: channel
  };

  getStreams() async {
    String path = serverIp + '/streams';

    final res = await _http.get(path);

    if (res != null && res.data != null) {
      final Map<String, dynamic> parsedData = _http.parseMapData(res.data)!;
      final Map<String, dynamic> payload =
          _http.parseMapData(parsedData['parsedData'])!;

      for (String roomId in payload.keys) {
        _roomIdHlsAddressMap = {
          ..._roomIdHlsAddressMap,
          roomId: parsedData[roomId],
        };
      }
    }
  }

  String getHlsAddress(String roomId) {
    return '$_serverIp/stream/$roomId/channel/0/hls/live/index.m3u8';
  }

  String _getWebRtcAddress(String roomId) {
    return '$_serverIp/stream/$roomId/channel/0/hls/live/index.m3u8';
  }

  // void requestWebRtc(String roomId) {
  //   final String address = '$_serverIp/stream/$roomId/channel/0/webrtc';
  // }

  // void requestHls(String roomId) {
  //   final String address =
  //       '$_serverIp/stream/$roomId/channel/0/hls/live/index.m3u8';
  // }
}