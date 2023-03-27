class User {
  final String iconUrl;
  final String name;
  final String id;
  final String description;
  final int followeesCount;
  final int followersCount;

  User({
    required this.iconUrl,
    required this.name,
    required this.id,
    required this.description,
    required this.followeesCount,
    required this.followersCount,
  });
}
