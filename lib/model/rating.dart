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
    rate.passenger_id=  json['passenger_id'];
    rate.comment=  json['comment'];
    rate.created_at=  json['created_at'];
    rate.rate=  json['rate'];
    rate.passenger_name = json['passenger_name'];
    return rate;
  }



}
