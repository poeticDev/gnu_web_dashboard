import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:gnu_web_dashboard/common/util/log_helper.dart';

const serverHttpApiIp = 'https://192.168.219.137/api/v1/';

class HttpManager {
  static final HttpManager _instance = HttpManager._internal();

  HttpManager._internal();

  factory HttpManager() {
    return _instance;
  }

  static Dio dio = Dio();
  static final _serverIp = serverHttpApiIp;

  Future<void> getTest({required String address}) async {
    try {
      final response = await dio.get(_serverIp);
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

    dio.options.headers = {'Content-Type': 'application/json'};

    try {
      final response = await dio.post('${_serverIp}read?type=messageData');
      dLog('response: $response');
    } catch (e) {
      eLog('post 테스트 실패 : $e');
    }
  }

  Future<Response?> post({
    required String path,
    Map<String, dynamic>? queryParameters,
    String? data,
  }) async {
    try {
      dio.options.headers = {'Content-Type': 'application/json'};

      final response = await dio.post(
        path,
        queryParameters: queryParameters,
        data: data,
      );

      dLog('post response: $response');

      return response;
    } catch (e) {
      eLog('post 요청 실패 : $e');
    }
    return null;
  }
}
