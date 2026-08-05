abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminSuccess extends AdminState {
  final String message;
  AdminSuccess(this.message);
}

class AdminFailure extends AdminState {
  final String errMessage;
  AdminFailure(this.errMessage);
}
