class OptionModel {
  final String name;
  final double price;

  OptionModel({required this.name, required this.price});
  factory OptionModel.fromJson(Map<String, dynamic> json) {
    return OptionModel(
      name: json['name']??'',
      price: json['price']??0,
    );
  }

}