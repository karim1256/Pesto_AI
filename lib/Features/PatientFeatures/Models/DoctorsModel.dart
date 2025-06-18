class DoctorModel {
  final String name;
  final List<String> raviews;
  final String cartificates;
  final String experience;
  final bool isFavourite;
  final List<double> rateing;
  final List<String> availableTime;
   final String id;
      final String image;

  DoctorModel({
    required this.name,
    required this.raviews,
    required this.cartificates,
    required this.experience,
    required this.isFavourite,
    required this.rateing,
    required this.availableTime,
    required this.id,
        required this.image,

    
  });

  factory DoctorModel.fromJson(Map<String, dynamic> json) {
    return DoctorModel(
      image:json['image'] ??"https://fneysqdotzuovzssvvrz.supabase.co/storage/v1/object/public/profile/doctors-profile/empty.jpg",
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      raviews: List<String>.from(json['raviews'] ?? []),
      cartificates: json['cartificates'] ?? '',
      experience: json['experience'] ?? '',
      isFavourite: json['is_favourite'] ?? false,
      rateing: List<double>.from(json['rateing']?.map((e) => e.toDouble()) ?? []),
      availableTime: List<String>.from(json['available_time'] ?? []),
    );
  }


  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'raviews': raviews,
      'cartificates': cartificates,
      'experience': experience,
      'is_favourite': isFavourite,
      'rateing': rateing,
      'available_time': availableTime,
    };
  }
}
