
import 'package:yosr_pos/model/item_extra_model.dart';
import 'package:yosr_pos/model/option_model.dart';

class CartItemExtra{
  final String id;
  final String title;
  List<OptionModel> options;

  CartItemExtra({required this.id, required this.title,required this.options,});

  factory CartItemExtra.parseItemExtra(ItemExtra itemExtra,List<OptionModel> selectedOptions){
    return CartItemExtra(id: itemExtra.id, title: itemExtra.title, options: selectedOptions);
  }

  factory CartItemExtra.fromJson(Map<String, dynamic> json) {
    return CartItemExtra(
      id: json['id']??json['extraId']??'',
      title: json['title'] ??'',
      options: json['options'] != null ? List<OptionModel>.from(json['options'].map((x) => OptionModel.fromJson(x))) : [],
    );
  }

}