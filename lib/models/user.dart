class User {
  late int? id;
  late String? fullname;
  late String? email;
  late String? picture;
  late bool? isVerified;
  late String? createdAt;
  late String? updatedAt;
  late String? ratingAvg;
  late String? firebaseToken;

  User(
      {this.id,
      this.fullname,
      this.email,
      this.picture,
      this.isVerified,
      this.ratingAvg,
      this.firebaseToken});

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fullname = json['fullname'];
    email = json['email'];
    picture = json['picture'];
    isVerified = json['isVerified'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    ratingAvg =
        (json['ratingAvg'] != null ? json['ratingAvg'].toString() : null);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['fullname'] = this.fullname;
    data['email'] = this.email;
    data['picture'] = this.picture;
    data['isVerified'] = this.isVerified;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['ratingAvg'] = this.ratingAvg;
    return data;
  }

  @override
  String toString() {
    return 'User: {id : $id, fn : $fullname, email : $email, pic : $picture, rate : $ratingAvg, isVerified: $isVerified}';
  }
}
