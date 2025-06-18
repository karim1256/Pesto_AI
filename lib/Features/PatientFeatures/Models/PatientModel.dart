class PatientModel {
  final String id;
  final String? email;
  final String? species;
  final String? breed;
  final String? gender;
  final String? history;
  final List? favourite_doctors;
  final int? age;
  final String? first_name;
  final String? last_name;
  final String? image;

  PatientModel({
    required this.id,
    this.email,
    this.species,
    this.breed,
    this.gender,
    this.history,
    this.favourite_doctors,
    this.age,
    this.first_name,
    this.last_name,
    this.image
  });

  factory PatientModel.fromJson(Map<String, dynamic> json) {
    return PatientModel(
      image: json['image']??"https://fneysqdotzuovzssvvrz.supabase.co/storage/v1/object/public/profile/doctors-profile/empty.jpg",
      id: json['id'] ?? '',
      email: json['email'],
      species: json['species'],
      breed: json['breed'],
      gender: json['gender'],
      history: json['history'],
      favourite_doctors: json['favourite_doctors'],
      age: json['age'],
      first_name: json['first_name'],
      last_name: json['last_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'species': species,
      'breed': breed,
      'gender': gender,
      'history': history,
      'favourite_doctors': favourite_doctors,
      'age': age,
      'first_name': first_name,
      'last_name': last_name,
    };
  }
}
