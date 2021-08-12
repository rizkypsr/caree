class Rating {
  int id;
  int ratingValue;

  Rating({required this.ratingValue, required this.id});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(id: json['id'], ratingValue: json['rating']);
  }
}
