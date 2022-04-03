class Rating {
  String? passenger_id;
  String? comment;
  String? created_at;
  String? passenger_image_url;
  String? passenger_name;
  String? rate_description;
  int? rate;
  Rating({
    this.passenger_id,
    this.comment,
    this.created_at,
    this.passenger_image_url,
    this.passenger_name,
    this.rate_description,
    this.rate,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
  Rating rate = Rating();
  rate.passenger_id= json['passenger_id'];
  rate.comment= json['comment'];
  rate.created_at= json['created_at'];
  rate.passenger_image_url= json['passenger_image_url'];
  rate.passenger_name= json['passenger_name'];
  rate.rate_description= json['rate_description'];
  rate.rate= json['rate'];  
    return rate;
  }

  Map<String, dynamic> toJson()=>{
    'passenger_id': passenger_id,
    'comment': comment,
    'created_at': created_at,
    'passenger_image_url': passenger_image_url,
    'passenger_name': passenger_name,
    'rate_description': rate_description,
    'rate': rate,
  };


}
