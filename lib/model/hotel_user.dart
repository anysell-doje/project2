class HotelUser {
  String user_email;
  String user_pw;
  String user_tel;
  String user_name;
  HotelUser(this.user_email, this.user_pw, this.user_tel, this.user_name);

  factory HotelUser.fromJson(Map<String, dynamic> json) => HotelUser(
        json['user_email'],
        json['user_pw'],
        json['user_tel'],
        json['user_name'],
      );

  Map<String, dynamic> toJson() => {
        'user_email': user_email,
        'user_tel': user_tel,
        'user_name': user_name,
      };
}
