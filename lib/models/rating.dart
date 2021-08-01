class Rating {
  String uuid;
  int ratingValue;

  Rating({required this.ratingValue, required this.uuid});

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(uuid: json['uuid'], ratingValue: json['rating']);
  }

  @override
  String toString() {
    return 'Rating: {uuid: ${uuid}, rating: ${ratingValue}}';
  }
}
