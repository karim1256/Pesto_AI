abstract class PatientFeaturesStates {}

class InitalPatientFeaturesState extends PatientFeaturesStates {}

class GetPatientMedicalDataLoadingState extends PatientFeaturesStates {}

class GetPatientMedicalDataSucceedState extends PatientFeaturesStates {}

class GetPatientMedicalDataFailureState extends PatientFeaturesStates {
  String Message;
  GetPatientMedicalDataFailureState(this.Message);
}

class GetDoctorDataLoadingState extends PatientFeaturesStates {}

class GetDoctorDataSucceedState extends PatientFeaturesStates {}

class GetDoctorDataFailureState extends PatientFeaturesStates {
  String Message;
  GetDoctorDataFailureState(this.Message);
}

class SearchSucceedState extends PatientFeaturesStates {}

class SearchfaildState extends PatientFeaturesStates {}

class SearchInitialState extends PatientFeaturesStates {}

class LocalFavouriteUpdateState extends PatientFeaturesStates {}

class FavouriteUpdateFailureState extends PatientFeaturesStates {
  String Message;
  FavouriteUpdateFailureState(this.Message);
}

class ReadMoreExparianceState extends PatientFeaturesStates {}

class ReadMoreCartificatesState extends PatientFeaturesStates {}

class GetSessionsSucceedState extends PatientFeaturesStates {}

class GetSessionsfaildState extends PatientFeaturesStates {
  String Message;
  GetSessionsfaildState(this.Message);
}

class GetSessionsState extends PatientFeaturesStates {}

class ExpandSessionState extends PatientFeaturesStates {}

class ConstProfileState extends PatientFeaturesStates {}

class changedProfileState extends PatientFeaturesStates {}

class ConstMedicalState extends PatientFeaturesStates {}

class changedMedicalState extends PatientFeaturesStates {}


class UpdatePatientProfileLoadingState extends PatientFeaturesStates {}

class UpdatePatientProfileSucceedState extends PatientFeaturesStates {}

class UpdatePatientProfileFailureState extends PatientFeaturesStates {
  String Message;
  UpdatePatientProfileFailureState(this.Message);
}

class UpdatePatientMedicalLoadingState extends PatientFeaturesStates {}

class UpdatePatientMedicalSucceedState extends PatientFeaturesStates {}

class UpdatePatientMedicalFailureState extends PatientFeaturesStates {
  String Message;
  UpdatePatientMedicalFailureState(this.Message);
}

class PatientGetBookingLoadingState extends PatientFeaturesStates {}

class PatientGetBookingSucceedState extends PatientFeaturesStates {}

class PatientGetBookingFailureState extends PatientFeaturesStates {
  String Message;
  PatientGetBookingFailureState(this.Message);
}/////

class ChoiceDateState extends PatientFeaturesStates {}

class ChoiceTimeState extends PatientFeaturesStates {}

class PatientBookingLoadingState extends PatientFeaturesStates {}

class PatientBookingSucceedState extends PatientFeaturesStates {}

class PatientBookingFailureState extends PatientFeaturesStates {
  String Message;
  PatientBookingFailureState(this.Message);
}


class NavigateState extends PatientFeaturesStates {}


class CloseSessionLoadingState extends PatientFeaturesStates {}

class CloseSessionSucceedState extends PatientFeaturesStates {}

class CloseSessionFailureState extends PatientFeaturesStates {
  String Message;
 CloseSessionFailureState(this.Message);
}





class UpdateCountState extends PatientFeaturesStates {}

class UpdateMeetingButtonState extends PatientFeaturesStates {}











class GetCalenderSessionsLoadingState extends PatientFeaturesStates {}

class GetCalenderSessionsSucceedState extends PatientFeaturesStates {}

class GetCalenderSessionFailureState extends PatientFeaturesStates {
  String Message;
 GetCalenderSessionFailureState(this.Message);
}





class UpdateDoctorDetailsState extends PatientFeaturesStates {}

class EndMeetingState extends PatientFeaturesStates {}




class AddRateingLoadingState extends PatientFeaturesStates {}

class  AddRateingSucceedState extends PatientFeaturesStates {}

class  AddRateingFailureState extends PatientFeaturesStates {
  String Message;
 AddRateingFailureState(this.Message);
}

/////image

class ImagePickedState extends PatientFeaturesStates {}

class ImageDeletedState extends PatientFeaturesStates {}

class ImageUploadedState extends PatientFeaturesStates {}

class ImageFatchedState extends PatientFeaturesStates {}



class GetCalenderDatesSucceedState extends PatientFeaturesStates {}




class PremiumAccountLoadingState extends PatientFeaturesStates {}

class  PremiumAccountSucceedState extends PatientFeaturesStates {}

class  PremiumAccountFailureState extends PatientFeaturesStates {
  String Message;
 PremiumAccountFailureState(this.Message);
}


class ModelLoadingState extends PatientFeaturesStates {}

class  ModelSucceedState extends PatientFeaturesStates {}

class  ModelFailureState extends PatientFeaturesStates {
  String Message;
 ModelFailureState(this.Message);
}



class UpdatePaymentCountState extends PatientFeaturesStates {}



class wifiUpdatedState extends PatientFeaturesStates {}
