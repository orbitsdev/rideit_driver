class Users {

  String? id;
  String? name;
  String? email;
  String? phone;

  Users({
    this.id,
    this.name,
    this.email,
    this.phone,
  });

  factory Users.fromJson(Map<String, dynamic> json){

    Users newuser = Users();
    newuser.id = json['id'];
    newuser.name = json['name'];
     newuser.email = json['email'];
     newuser.phone = json['phone'];

  return newuser;

  }

}
