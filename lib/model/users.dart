class Users {

  String? id;
  String? name;
  String? email;
  String? phone;
  String? image_url;
  String? image_file;
  String? device_token;
  bool? new_acount;
  String? map_mode;

  Users({
    this.id,
    this.name,
    this.email,
    this.phone,
    this.image_url,
    this.image_file,
    this.device_token,
    this.new_acount,
    this.map_mode,

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
    newuser.new_acount = json["new_acount"];
    newuser.map_mode = json[" map_mode"];

    return newuser;
  }
  Map<String, dynamic> toJson() => {
     'id':  id,
    'name':     name,
    'email':     email,
    'phone':     phone,
    'image_url':     image_url,
    'image_file':     image_file,
    'device_token':     device_token,
    'new_acount':     new_acount,
    ' map_mode':      map_mode,

  };


}