class RestaurantProductModel {
  String? id;
  String? name;
  num? price;
  num? finalPrice;
  bool? available;
  num? sortOrder;
  String? description;
  String? image;
  bool? hide;
  String? categoryName;
  String? restaurantId;

  RestaurantProductModel(
      {this.id,
        this.name,
        this.price,
        this.finalPrice,
        this.available,
        this.sortOrder,
        this.description,
        this.image,
        this.hide,
        this.categoryName,
        this.restaurantId});

  RestaurantProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    finalPrice = json['finalPrice'];
    available = json['available'];
    sortOrder = json['sortOrder'];
    description = json['description'];
    image = json['image'];
    hide = json['hide'];
    categoryName = json['categoryName'];
    restaurantId = json['restaurantId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['price'] = price;
    data['finalPrice'] = finalPrice;
    data['available'] = available;
    data['sortOrder'] = sortOrder;
    data['description'] = description;
    data['image'] = image;
    data['hide'] = hide;
    data['categoryName'] = categoryName;
    data['restaurantId'] = restaurantId;
    return data;
  }
}
