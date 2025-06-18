
abstract class DoctorFeaturesStates {}




class InitalDoctorFeaturesState extends DoctorFeaturesStates {}
class GetDoctorMedicalDataLoadingState extends DoctorFeaturesStates {}
class GetDoctorMedicalDataSucceedState extends DoctorFeaturesStates {}
class GetDoctorMedicalDataFailureState extends DoctorFeaturesStates {
 String Message;
GetDoctorMedicalDataFailureState(this.Message);

}

class ChooceTimeState extends DoctorFeaturesStates {}
class ChooceDateState extends DoctorFeaturesStates {}


class GetAvalTimeLoadingState extends DoctorFeaturesStates {}
class GetAvalTimeSucceedState extends DoctorFeaturesStates {}
class GetAvalTimeFailureState extends DoctorFeaturesStates {
 String Message;
GetAvalTimeFailureState(this.Message);

}


class UpdateAvalTimeLoadingState extends DoctorFeaturesStates {}
class UpdateAvalTimeSucceedState extends DoctorFeaturesStates {}
class UpdateAvalTimeFailureState extends DoctorFeaturesStates {
 String Message;
UpdateAvalTimeFailureState(this.Message);

}



class UpdateDoctorMedicalLoadingState extends DoctorFeaturesStates {}
class UpdateDoctorMedicalSucceedState extends DoctorFeaturesStates {}
class UpdateDoctorMedicalFailureState extends DoctorFeaturesStates {
 String Message;
UpdateDoctorMedicalFailureState(this.Message);

}


class schadgleLoadingState extends DoctorFeaturesStates {}
class schadgleSucceedState extends DoctorFeaturesStates {}
class schadgleFailureState extends DoctorFeaturesStates {
 String Message;
schadgleFailureState(this.Message);

}



class UpdateMeetingDetailsgState extends DoctorFeaturesStates {}



class SessionsResultLoadingState extends DoctorFeaturesStates{}

class SessionsResultSucceedState extends DoctorFeaturesStates {}

class SessionsResultFailureState extends DoctorFeaturesStates {
  String Message;
 SessionsResultFailureState(this.Message);
}



// class PastPatientsLoadingState extends DoctorFeaturesStates{}

// class PastPatientsSucceedState extends DoctorFeaturesStates {}

// class PastPatientsFailureState extends DoctorFeaturesStates {
//   String Message;
//  PastPatientsFailureState(this.Message);
// }





class alreadyBookedLoadingState extends DoctorFeaturesStates {}
class alreadyBookedSucceedState extends DoctorFeaturesStates {}
class alreadyBookedFailureState extends DoctorFeaturesStates {
 String Message;
alreadyBookedFailureState(this.Message);

}




class drDataLoadingState extends DoctorFeaturesStates {}
class drDataSucceedState extends DoctorFeaturesStates {}
class drDataFailureState extends DoctorFeaturesStates {
 String Message;
drDataFailureState(this.Message);

}