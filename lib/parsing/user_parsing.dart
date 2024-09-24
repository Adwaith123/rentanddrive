class UserValues{
  UserValues( {required this.name,required this.phoneNumber,required this.selected,
    required this.type});
  // non-nullable - assuming the score field is always present

  final String name;
  final String phoneNumber;
  final String selected;
  final String type;





  factory UserValues.fromJson(Map<String, dynamic> data) {


    final String name=data['name'] as String;
    final String phoneNumber=data['phone'] as String;
    final String selected=data['selected'] as String;
    final String type=data['type'] as String;




    return  UserValues(name: name,phoneNumber: phoneNumber,selected:selected,type: type);
  }
}

