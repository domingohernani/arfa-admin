class Customer {
  String? id;
  String? firstname;
  String? lastname;
  String? email;
  String? phone;
  String? role;
  Map<String, String>? location = {};

  Customer({
    this.id,
    this.firstname,
    this.lastname,
    this.email,
    this.phone,
    this.role,
    this.location,
  });

  factory Customer.fromFirestore(var snapshot) {
    final data = snapshot;

    return Customer(
      id: data["id"],
      firstname: data["firstname"],
      lastname: data["lastname"],
      email: data["email"],
      phone: data["phoneNumber"],
      role: data["role"],
      location: {
        "street": data["location"]["street"],
        "barangay": data["location"]["barangay"],
        "city": data["location"]["city"],
        "province": data["location"]["province"],
        "region": data["location"]["region"],
      },
    );
  }
}
