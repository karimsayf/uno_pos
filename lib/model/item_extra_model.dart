import 'package:yosr_pos/model/option_model.dart';

class ItemExtra{
  final String id;
  final String title;
  final List<OptionModel> options;
  final String checkType;
  final String mandatoryType;

  ItemExtra({required this.id, required this.title,required this.options, required this.checkType, required this.mandatoryType});

  factory ItemExtra.fromJson(Map<String, dynamic> json) {
    return ItemExtra(
      id: json['id']??'',
      title: json['title'] ??'',
      options: json['options'] != null ? List<OptionModel>.from(json['options'].map((x) => OptionModel.fromJson(x))) : [],
      checkType: json['checkType']??'',
      mandatoryType: json['mandatoryType']??'',
    );
  }
}