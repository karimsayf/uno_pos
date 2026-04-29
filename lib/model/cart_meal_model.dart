import 'package:yosr_pos/model/cart_item_extra_model.dart';

class CartMealModel {
  final String id;
  final String itemId;
  final String itemName;
  final String itemImage;
  final String itemDescription;
  final double unitPrice;
  final double lineTotal;
  int quantity;
  final List<CartItemExtra> cartItemExtras;
  CartMealModel({
    required this.id,
    required this.itemId,
    required this.itemName,
    required this.itemDescription,
    required this.unitPrice,
    required this.lineTotal,
    required this.quantity,
    required this.itemImage,
    required this.cartItemExtras
  });

  factory CartMealModel.fromJson(Map<String, dynamic> json) {
    return CartMealModel(
      id: json['id'],
      itemId: json['itemId']??'',
      itemName: json['itemName']??'',
        itemDescription: json['itemDescription']??'',
        unitPrice: json['unitPrice']??0,
        lineTotal: json['lineTotal']??0,
      quantity: json['quantity'] ?? 0,
      itemImage: json['itemImage']??'',
      cartItemExtras: json['cartItemExtras'] != null ? List<CartItemExtra>.from(json['cartItemExtras'].map((x) => CartItemExtra.fromJson(x))) : [],
    );
  }

  factory CartMealModel.fromOrderJson(Map<String, dynamic> json) {
    return CartMealModel(
      id: json['id'],
      itemId: json['itemId']??'',
      itemName: json['itemName']??'',
      itemDescription: json['itemDescription']??'',
      unitPrice: json['unitPrice']??0,
      lineTotal: json['lineTotal']??0,
      quantity: json['quantity'] ?? 0,
      itemImage: json['itemImage']??'',
      cartItemExtras: json['orderItemExtras'] != null ? List<CartItemExtra>.from(json['orderItemExtras'].map((x) => CartItemExtra.fromJson(x))) : [],
    );
  }


}
