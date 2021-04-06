class ProfileModel {
  final String userName,
      userid,
      userProfilelink,
      email,
      category,
      engrate,
      avgLike;

  ProfileModel(
      {this.userName,
      this.userid,
      this.userProfilelink,
      this.email,
      this.category,
      this.engrate,
      this.avgLike});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel();
  }
}
