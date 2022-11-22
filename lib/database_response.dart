class DatabaseResponse {
  String? name;
  String? email;
  String? dob;
  String? password;
  String? confirmPassword;

  DatabaseResponse({this.name, this.email, this.dob, this.password,this.confirmPassword});

  DatabaseResponse.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    dob = json['dob'];
    password = json['password'];
    confirmPassword = json['confirmPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['dob'] = dob;
    data['password'] = password;
    data['confirmPassword'] = confirmPassword;
    return data;
  }
}
// List userDetail=[
//   {
//     "name":"Navneet",
//     "email":"abc@gmail.com",
//     "dob":"7/1/1981",
//     "password":"123456"
//   }
// ];