
class UserModel{
  int id;
  String username;
  String email;
  String photo;
  UserModel({this.id,this.email,this.photo,this.username});


  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["id"],
      username: json["name"],
      email: json["email"],
      photo: json["image"]
    );
  }

  Map<String ,dynamic>toUser() {
    return {
      "name":username,
      "email":email,
      "image":photo,
    };
  }
}