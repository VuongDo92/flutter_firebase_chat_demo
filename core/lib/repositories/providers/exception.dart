// Users of any providers should catch these exceptions, this is to abstract away the library specific exception (for example DioError for HTTP)
abstract class DataProviderException extends Error implements Exception {
  // User-friendly title for the message
  final String title;
  // User-friendly message for the exception, should provide solution if possbile
  final String message;
  // It is temporary exception, simply retry might work
  final bool isTemporary;
  // Should not display the title/message to user via alerts/toast
  final bool isSilent;

  final dynamic originalException;

  @override
  String toString() {
    return message ?? title;
  }

  DataProviderException({
    this.title,
    this.message,
    this.originalException = null,
    this.isTemporary = false,
    this.isSilent = false,
  });
}

/**
 * Request is taking too long
 */
class TimeOutException extends DataProviderException {
  TimeOutException({String title, String message, dynamic originalException})
      : super(
            title: title,
            message: message = 'Request timeout',
            isTemporary: true);
}

/**
 * DNS error or server refuse connection (409, too many requests)
 */
class ConnectionException extends DataProviderException {
  ConnectionException({String title, String message = 'Unable to connect'})
      : super(title: title, message: message, isTemporary: true);
}

/**
 * Cannot connect to internet, etc
 */
class NetworkException extends DataProviderException {
  NetworkException({String title, String message})
      : super(title: title, message: message, isTemporary: true);
}

/**
 * 5xx error
 */
class ServerException extends DataProviderException {
  ServerException({String title, String message})
      : super(title: title, message: message);
}

/**
 * Token expired or need to login
 */
class UnauthorizedException extends DataProviderException {
  UnauthorizedException({dynamic originalException})
      : super(isSilent: true, originalException: originalException);
}

/**
 * We don't have access to perform that request. This is 403.
 */
class ForbiddenException extends DataProviderException {
  ForbiddenException({String title, String message})
      : super(title: title, message: message);
}

class DeprecationException extends DataProviderException {
  DeprecationException({dynamic originalException})
      : super(
          isSilent: true,
          isTemporary: false,
          originalException: originalException,
        );
}

/**
 * Unable to find that resource.  This is a 404.
 */
class NotfoundException extends DataProviderException {
  NotfoundException({String title, String message, dynamic originalException})
      : super(
            title: title,
            message: message,
            originalException: originalException);
}

/**
 * All other 4xx series errors.
 */
class RejectedException extends DataProviderException {
  RejectedException({String title, String message, dynamic originalException})
      : super(
            title: title,
            message: message,
            originalException: originalException);
}

/**
 * Something truly unexpected happened. Most likely can try again. This is a catch all.
 */
class UnknownException extends DataProviderException {
  UnknownException({
    title,
    message,
    originalException,
    isTemporary = true,
    isSilent = false,
  }) : super(
          title: title,
          message: message,
          originalException: originalException,
          isTemporary: isTemporary,
          isSilent: isSilent,
        );
}

/**
 * The data we received is not in the expected format, bad data
 */
class ClientException extends DataProviderException {
  ClientException({String title, String message})
      : super(title: title, message: message);
}

/**
 * The client cancel the request
 */
class CancelException extends DataProviderException {
  CancelException({String title, String message})
      : super(title: title, message: message, isSilent: true);
}
