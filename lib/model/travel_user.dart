class TravelUser {
  String travel_email;
  String travel_tel;
  String travel_name;
  TravelUser(this.travel_email, this.travel_tel, this.travel_name);

  factory TravelUser.fromJson(Map<String, dynamic> json) => TravelUser(
        json['travel_email'],
        json['travel_tel'],
        json['travel_name'],
      );
}
