import 'package:dartz/dartz.dart';

import 'failures.dart';

void failureHandler(
    Either<Failure, dynamic> result, void Function() onSuccess) {
  result.fold(
    (l) {
      return; //snackBarShower( l.message??"Something wrong please try again later.");
    },
    (r) {
      onSuccess();
    },
  );
}
