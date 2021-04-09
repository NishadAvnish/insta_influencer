class ProfileModel {
  final String userName,
      userid,
      userProfilelink,
      email,
      category,
      engrate,
      avgLike;
  final int currentNo;

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
}
