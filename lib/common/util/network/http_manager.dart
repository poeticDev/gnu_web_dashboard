import 'package:dio/dio.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';

const serverHttpApiIp = 'https://117.16.154.97/api/v1';

class HttpManager {
  static final HttpManager _instance = HttpManager._internal();

  HttpManager._internal();

  factory HttpManager() {
    if (_serverIp.endsWith('/')) {
      _serverIp = _serverIp.substring(0, _serverIp.length - 1);
    }

    return _instance;
  }

  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: _serverIp,
      headers: {'Content-Type': 'application/json'},
      sendTimeout: Duration(seconds: 5),
      receiveTimeout: Duration(seconds: 5),
    ),
  );

  Dio get dio => _dio;

  static String _serverIp = serverHttpApiIp;

  Future<void> getTest({required String address}) async {
    try {
      final response = await _dio.get(_serverIp);
      dLog('response: $response');
    } catch (e) {
      eLog('get 테스트 실패 : $e');
    }
  }

  Future<void> postTest() async {
    // dio.httpClientAdapter = IOHttpClientAdapter(
    //   validateCertificate:  (cert, host, port) {
    //     return true;
    //   }
    // );

    try {
      final response = await _dio.post('/read?type=messageData');
      dLog('response: $response');
    } catch (e) {
      eLog('post 테스트 실패 : $e');
    }
  }

  Future<Response?> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(path, queryParameters: queryParameters);
      dLog('📡 GET [$path] → ${response.statusCode}');
      return response;
    } catch (e) {
      eLog('GET 요청 실패: $e');
      return null;
    }
  }

  Future<Response?> post({
    String path = serverHttpApiIp,
    Map<String, dynamic>? queryParameters,
    dynamic data,
    Options? options,
  }) async {
    try {
      _dio.options.headers = {'Content-Type': 'application/json'};

      final response = await _dio.post(
        path,
        queryParameters: queryParameters,
        data: data,
        options: options,
      );

      dLog('POST $path: ${response.statusCode}');

      return response;
    } catch (e) {
      eLog('POST 요청 실패 : $e');
    }
    return null;
  }
}
