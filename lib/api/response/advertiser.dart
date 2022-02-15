/// Advertiser
class Advertiser {
  /// Advertiser const
  Advertiser({this.firstName, this.id, this.lastName, this.name});

  /// Advertiser const
  factory Advertiser.fromMap(Map<String, dynamic> advertiser) => Advertiser(
      firstName: advertiser['first_name'],
      id: advertiser['id'],
      lastName: advertiser['last_name'],
      name: advertiser['name']);

  /// firstName val
  final String? firstName;

  /// id val
  final String? id;

  /// lastName val
  final String? lastName;

  /// name val
  final String? name;
}
