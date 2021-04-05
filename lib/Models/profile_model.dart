class ProfileModel {
  final String name,
      userid,
      userProfilelink,
      website,
      category,
      engrate,
      avgLike;

  ProfileModel(
      {this.name,
      this.userid,
      this.userProfilelink,
      this.website,
      this.category,
      this.engrate,
      this.avgLike});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel();
  }
}
