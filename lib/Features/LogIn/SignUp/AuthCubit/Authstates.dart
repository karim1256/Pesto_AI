abstract class AuthStates {}

class InitalAuthState extends AuthStates {}

class RegisterLoadingState extends AuthStates {}

class RegisterSucceedState extends AuthStates {}

class RegisterFailureState extends AuthStates {
  String Message;
  RegisterFailureState(this.Message);
}

class LogInLoadingState extends AuthStates {}

class LogInSucceedState extends AuthStates {}

class LogInFailureState extends AuthStates {
  String Message;
  LogInFailureState(this.Message);
}

class LogOutLoadingState extends AuthStates {}

class LogOutSucceedState extends AuthStates {}

class LogOutFailureState extends AuthStates {
  String Message;
  LogOutFailureState(this.Message);
}

class MagicLinkLoadingState extends AuthStates {}

class MagicLinkSentState extends AuthStates {}

class MagicLinkErrorState extends AuthStates {
  String Message;
  MagicLinkErrorState(this.Message);
}

class OnboardingNavigateState extends AuthStates {}





class PastPatientsLoadingState extends AuthStates{}

class PastPatientsSucceedState extends AuthStates {}

class PastPatientsFailureState extends AuthStates {
  String Message;
 PastPatientsFailureState(this.Message);
}


class ConnectionChangeState extends AuthStates {}
