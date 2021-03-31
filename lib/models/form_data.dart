class FormData{

  String name;
  String phoneNumber;
  String imageUrl;
  double lat;
  double lng;
  String uuid;

  FormData({this.name,this.phoneNumber,this.imageUrl,this.lat,this.lng,this.uuid});

  FormData.fromJson(Map<String,dynamic> json){
    name = json["name"];
    phoneNumber = json["phoneNumber"];
    imageUrl = json["imageUrl"];
    lat = json["lat"];
    lng = json["lng"];
    uuid = json["uuid"];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['imageUrl'] = this.imageUrl;
    data['lat'] = this.lat;
    data['lng'] = this.lng;
    data['uuid'] = this.uuid;
    return data;
  }



}