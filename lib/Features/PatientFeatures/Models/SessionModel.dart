class SessionModel {
  final int id;
  final String doctorId;
  
  final String date;
  final String history;
  final String diagnosis;
  final String recommendation;
  final String patientId;

  SessionModel({
    required this.id,
    required this.doctorId,
    required this.date,
    required this.history,
    required this.diagnosis,
    required this.recommendation,
    required this.patientId,
  });

  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] ?? 0,
      doctorId: json['doctor_id'] ?? 0,
      date: json['date'] ?? '',
      history: json['history'] ?? '',
      diagnosis: json['diagnosis'] ?? '',
      recommendation: json['recommendation'] ?? '',
      patientId: json['patient_id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'doctor_id': doctorId,
      'date': date,
      'history': history,
      'diagnosis': diagnosis,
      'recommendation': recommendation,
      'patient_id': patientId,
    };
  }
}