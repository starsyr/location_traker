class UserModel {
  final String name;
  final Map location;
  final bool isAdmin;

  UserModel({
    required this.name,
    required this.location,
    required this.isAdmin,
  });



  factory UserModel.fromSnapshot(Map d){
    return UserModel(name: d['name'], location: d['location'], isAdmin: d['isAdmin']);
  }



  toJson(){
    return {
      'name': name,
      'location': location,
      'isAdmin': isAdmin
    };
  }
}
