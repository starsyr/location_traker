class UserRequestModel{
  final String usr;
  final String pwd;

  UserRequestModel(this.usr, this.pwd);

  @override
  String toString() {
    return 'UserRequestModel{usr: $usr, pwd: $pwd}';
  }
}