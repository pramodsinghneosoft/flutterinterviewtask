class BreweryModel {
  int id;
  String name;
  String breweryType;
  String street;
  String city;
  String state;
  String postalCode;
  String country;
  String longitude;
  String latitude;
  String phone;
  String websiteUrl;
  String updatedAt;

  BreweryModel(
      {this.id,
      this.name,
      this.breweryType,
      this.street,
      this.city,
      this.state,
      this.postalCode,
      this.country,
      this.longitude,
      this.latitude,
      this.phone,
      this.websiteUrl,
      this.updatedAt});

  BreweryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    breweryType = json['brewery_type'];
    street = json['street'];
    city = json['city'];
    state = json['state'];
    postalCode = json['postal_code'];
    country = json['country'];
    longitude = json['longitude'];
    latitude = json['latitude'];
    phone = json['phone'];
    websiteUrl = json['website_url'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['brewery_type'] = this.breweryType;
    data['street'] = this.street;
    data['city'] = this.city;
    data['state'] = this.state;
    data['postal_code'] = this.postalCode;
    data['country'] = this.country;
    data['longitude'] = this.longitude;
    data['latitude'] = this.latitude;
    data['phone'] = this.phone;
    data['website_url'] = this.websiteUrl;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
