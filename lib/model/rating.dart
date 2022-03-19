class Rating {
  String? passenger_id;
  String? comment;
  String? created_at;
  String? passenger_name;
  double? rate;

  Rating({
    this.passenger_id,
    this.comment,
    this.created_at,
    this.rate,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    Rating rate = Rating();
    rate.rate=  json['rate'];
    rate.comment=  json['comment'];
    rate.passenger_id=  json['passenger_id'];
    rate.passenger_name = json['passenger_name'];
    rate.created_at=  json['created_at'];
    return rate;
  }



}
