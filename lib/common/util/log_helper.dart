import 'package:logger/web.dart';

var logger = Logger(
  printer: PrettyPrinter(
    methodCount: 0,
    errorMethodCount: 8
  )
);

void tLog(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
    logger.t(message, error: error, stackTrace: stackTrace);

void dLog(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
    logger.d(message, error: error, stackTrace: stackTrace);

void iLog(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
    logger.i(message, error: error, stackTrace: stackTrace);

void wLog(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
    logger.w(message, error: error, stackTrace: stackTrace);

void eLog(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
    logger.e(message, error: error, stackTrace: stackTrace);

void fLog(dynamic message, [dynamic error, StackTrace? stackTrace]) =>
    logger.f(message, error: error, stackTrace: stackTrace);
