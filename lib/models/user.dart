class User {
  late String? uuid;
  late String fullname;
  late String email;
  late String phone;
  late String? picture;
  late bool? isVerified;
  late String? createdAt;
  late String? updatedAt;
  late String? ratingAvg;

  User(
      {this.uuid,
      required this.fullname,
      required this.email,
      required this.phone,
      this.picture,
      this.isVerified,
      this.ratingAvg});

  User.fromJson(Map<String, dynamic> json) {
    uuid = json['uuid'];
    fullname = json['fullname'];
    email = json['email'];
    picture = json['picture'];
    isVerified = json['isVerified'];
    phone = json['phone'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ratingAvg =
        (json['ratingAvg'] != null ? json['ratingAvg'].toString() : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uuid'] = this.uuid;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['picture'] = this.picture;
    data['phone'] = this.phone;
    data['isVerified'] = this.isVerified;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['ratingAvg'] = this.ratingAvg;
    return data;
  }

  @override
  String toString() {
    return 'User: {id : $uuid, fn : $fullname, email : $email, pic : $picture, rate : $ratingAvg, isVerified: $isVerified}';
  }
}
