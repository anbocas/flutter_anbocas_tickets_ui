import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

String handleAnbocasApiException(Exception? e) {
  if (e != null) {
    if (e is DioException) {
      var dioException = e;
      if (dioException.type == DioExceptionType.badResponse &&
          dioException.response != null) {
        return _handleBadResponse(dioException.response!);
      } else {
        return _handleGenericError(e.type);
      }
    } else {
      return "An unexpected error occurred: ${e.toString()}";
    }
  } else {
    return "Something Went wrong";
  }
}

String _handleGenericError(DioExceptionType type) {
  switch (type) {
    case DioExceptionType.connectionTimeout:
      return "Connection timeout occurred.";
    case DioExceptionType.receiveTimeout:
      return "Receive timeout in connection with server.";
    case DioExceptionType.sendTimeout:
      return "Send timeout in connection with server.";
    case DioExceptionType.cancel:
      return "Request was cancelled.";
    default:
      return "Connection failed due to internet connection.";
  }
}

String _handleBadResponse(Response response) {
  if (kDebugMode) {
    print('\x1B[31m ====[ ERROR ]=====>>  ${response.data.toString()} \x1B[0m');
  }
  int? statusCode = response.statusCode;
  if (statusCode != null) {
    switch (statusCode) {
      case 400:
        if (response.data != null && response.data.containsKey('message')) {
          return response.data['message'];
        } else {
          return "Bad request.";
        }
      case 401:
        return "Unauthorized.";
      case 403:
        return "Forbidden.";
      case 404:
        return "Not found.";
      case 422:
        if (response.data != null && response.data.containsKey('errors')) {
          Map<String, dynamic> errors = response.data['errors'];
          final List<String> errorMessage = [];
          if (errors.isNotEmpty) {
            errors.forEach((key, value) {
              if (value is List) {
                errorMessage.add(value[0]);
              } else {
                errorMessage.add(value.toString());
              }
            });
          }
          return errorMessage.join(", ");
        } else {
          return "An error occurred";
        }

      default:
        return "Received invalid status code: $statusCode";
    }
  } else {
    return "Received invalid response.";
  }
}
