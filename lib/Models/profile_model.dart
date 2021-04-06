class ProfileModel {
  final String userName,
      userid,
      userProfilelink,
      email,
      category,
      engrate,
      avgLike,
      currentNo;

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
    return ProfileModel();
  }
}
