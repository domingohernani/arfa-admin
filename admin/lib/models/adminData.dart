class Admin {
  String id = "";
  String email = "";
  String name = "";
  String role = "";

  Admin({
    required this.id,
    required this.email,
    required this.name,
    required this.role,
  });

  factory Admin.fromFirestore(var snapshot) {
    final data = snapshot;

    return Admin(
        id: data["id"],
        email: data["email"],
        name: data["name"],
        role: data["role"]);
  }
}
