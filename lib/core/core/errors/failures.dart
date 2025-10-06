import 'package:dio/dio.dart';
import 'package:get/get.dart';

abstract class Failure {
  final String message;

  const Failure(this.message);
}

class ServerFailure extends Failure {
  ServerFailure(super.message);

  factory ServerFailure.fromDioException(DioException dioException) {
    switch (dioException.type) {
      case DioExceptionType.connectionTimeout:
        return ServerFailure('Connection timeout with ApiServer');
      case DioExceptionType.sendTimeout:
        return ServerFailure('Send timeout with ApiServer');
      case DioExceptionType.receiveTimeout:
        return ServerFailure('Receive timeout with ApiServer');
      case DioExceptionType.badResponse:
        return ServerFailure.fromResponse(
            dioException.response!.statusCode, dioException.response!.data);
      case DioExceptionType.cancel:
        return ServerFailure('Request to ApiServer was canceld');
      case DioExceptionType.unknown:
        if (dioException.message!.contains('SocketException')) {
          if (Get.currentRoute != "/SomethingWrongPageScaffold") {
            /* Go.offAll(SomethingWrongPageScaffold(
              title: 'No Internet Connection',
            )); */
          }

          return ServerFailure('No Internet Connection');
        }
        return ServerFailure('Unexpected Error, Please try again!');
      default:
        return ServerFailure('Opps There was an Error, Please try again');
    }
  }

  //
  // factory ServerFailure.fromFirebaseAuthException(
  //     FirebaseAuthException exception) {
  //   switch (exception.code) {
  //     case 'invalid-email':
  //       return ServerFailure('Invalid email address');
  //     case 'user-not-found':
  //       return ServerFailure('User not found');
  //     case 'wrong-password':
  //       return ServerFailure('Wrong password');
  //     case 'user-disabled':
  //       return ServerFailure('User account is disabled');
  //     case 'too-many-requests':
  //       return ServerFailure('Too many requests. Please try again later.');
  //     case 'email-already-in-use':
  //       return ServerFailure('The email address is already in use');
  //     case 'weak-password':
  //       return ServerFailure('The password is too weak');
  //     default:
  //       return ServerFailure('${exception.code}');
  //
  //   }
  // }

  factory ServerFailure.fromResponse(int? statusCode, dynamic response) {
    if (statusCode == 400 || statusCode == 403) {
      String errorMessage = '';
      if (response['validation'] != null) {
        Map<String, dynamic> messages = response['validation'];
        List messagesList = messages.values.toList();
        for (int i = 0; i < messagesList.length; i++) {
          if (i == 0)
            errorMessage += messagesList[i];
          else
            errorMessage += '\n${messagesList[i]}';
        }
      } else
        errorMessage = response['message'];
      return ServerFailure(errorMessage);
    } else if (statusCode == 401) {
      //if(Get.currentRoute != "/LoginInPageView")
      //CoreInfo.logOut(fromFailures: true);
      return ServerFailure("Your session has ended");
    } else if (statusCode == 422) {
      String errorMessage = '';
      if (response['validation'] != null) {
        Map<String, dynamic> messages = response['validation'];
        List messagesList = messages.values.toList();
        for (int i = 0; i < messagesList.length; i++) {
          if (i == 0)
            errorMessage += messagesList[i];
          else
            errorMessage += '\n${messagesList[i]}';
        }
      } else
        errorMessage = response['message'];
      return ServerFailure(errorMessage);
    } else if (statusCode == 404) {
      return ServerFailure('Your request not found, Please try later!');
    } /* else if (statusCode == 307) {
      switch (response['redirction'].toString())
      {
        case "kyc":
          Future.delayed(Duration(seconds: 1)).then((value) => Go.to(IdCardActivationPageView()));
          break;
        case 'kycPending':
          Future.delayed(Duration(seconds: 1)).then((value) => Go.to(KycPendingPageView()));
          break;
        case 'verify_phone_otp':
          Future.delayed(Duration(seconds: 1)).then((value) => Go.to(VerificationCodePageView(phone:GetStorage().read('phoneShared'),fromCreateAccount: false,)));
          break;

      }
      return ServerFailure(response['message']);
    } */
    else if (statusCode == 500) {
      return ServerFailure('Internal Server error, Please try later');
    } else {
      return ServerFailure('Opps There was an Error, Please try again');
    }
  }
}
