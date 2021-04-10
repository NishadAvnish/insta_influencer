class ProfileModel {
  String userName, userid, userProfilelink, email, category, engrate, avgLike;
  int currentNo;

  ProfileModel(
      {this.userName,
      this.userid,
      this.userProfilelink,
      this.email,
      this.category,
      this.engrate,
      this.avgLike,
      this.currentNo});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      userName: json["userName"],
      userid: json["userId"].toString(),
      userProfilelink: json["userProfile"],
      email: json["email"],
      category: json["category"],
      engrate: json["engRate"].toString(),
      avgLike: json["avgLikes"].toString(),
      currentNo: json["currentNo"],
    );
  }
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      "userName": userName,
      "userid": userid,
      "userProfilelink": userProfilelink,
      "email": email,
      "category": category,
      "engrate": engrate,
      "avgLike": avgLike
    };

    return map;
  }

  // ProfileModel.fromMaps(Map<String, dynamic> map) {
  //   userName = map["userName"];
  //   userid = map["userid"];
  //   userProfilelink = map["userProfilelink"];
  //   email = map["email"];
  //   category = map["category"];
  //   engrate = map["engrate"];
  //   avgLike = map["avgLike"];
  // }
}
