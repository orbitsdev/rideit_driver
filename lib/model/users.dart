class Users {

  String? id;
  String? name;
  String? email;
  String? phone;
  String? image_url;
  String? image_file;
  String? device_token;

  Users({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image_url,
    this.image_file,
    this.device_token,

  });  
  
  
  factory Users.fromJson(Map<String, dynamic> json){

    Users newuser = Users();
    newuser.id = json['id'];
    newuser.name = json['name'];
    newuser.email = json['email'];
    newuser.phone = json['phone'];
    newuser.image_url = json["image_url"];
    newuser.image_file = json["image_file"];
    newuser.image_file = json["device_token"];
    return newuser;
  }



}