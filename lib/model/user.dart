class UserModel {
  final String id;
  final String name;
  final List<Map> location;
  final bool isAdmin;

  UserModel({
    required this.id,
    required this.name,
    required this.location,
    required this.isAdmin,
  });



  factory UserModel.fromSnapshot(Map<String, dynamic> d){
    return UserModel(id: d['id'], name: d['name'], location: List<Map>.from(d['location']), isAdmin: d['isAdmin']);
  }



  toJson(){
    return {
      'id': id,
      'name': name,
      'location': location,
      'isAdmin': isAdmin
    };
  }
}
