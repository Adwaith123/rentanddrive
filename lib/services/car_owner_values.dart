class GetCarOwnerValues{
  GetCarOwnerValues( {required this.fuelType,required this.name,required this.city,
  required this.district,required this.kmreading,required this.requests,required this.intent,
  required this.uid,required this.milage,required this.price,required this.imageurl,required this.seatno,
  required this.selected,required this.modelname});
  // non-nullable - assuming the score field is always present

final String fuelType;
final String name;
final String city;
final String district;
final String kmreading;
final List<dynamic> requests;
final String intent;
final String uid;
final String milage;
final String price;
final String imageurl;
final String seatno;
final String selected;
final String modelname;



  factory GetCarOwnerValues.fromJson(Map<String, dynamic> data) {


    final String fuelType=data['fueltype'] as String;
    final String name=data['firstname'] as String;
    final String city=data['city'] as String;
    final String district=data['district'] as String;
    final String kmreading=data['kmreading'] as String;
    final List<dynamic> requests=data['requests'] as List<dynamic>;
    final String intent=data['intent'] as String;
    final String uid=data['uid'] as String;
    final String milage=data['milage'] as String;
    final String price=data['price'] as String;
    final String imageurl=data['imageurl'] as String;
    final String seatno=data['seatno'] as String;
    final String selected=data['selected'] as String;
    final String modelname=data['modelname'] as String;



    return  GetCarOwnerValues(fuelType: fuelType,name: name,city:city,district: district,kmreading: kmreading,
    requests: requests,intent: intent,uid: uid,milage: milage,price: price,imageurl: imageurl,seatno: seatno,
        selected:selected ,modelname: modelname);
  }
}