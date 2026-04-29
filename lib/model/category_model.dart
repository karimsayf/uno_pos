class CategoryModel {
  String? id;
  String? name;
  String? photo;
  String? parentId;
  String? parentName;
  int? sortOrder;

  CategoryModel(
      {this.id,
        this.name,
        this.photo,
        this.parentId,
        this.parentName,
        this.sortOrder});

  CategoryModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    photo = json['photo'];
    parentId = json['parentId'];
    parentName = json['parentName'];
    sortOrder = json['sortOrder'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['photo'] = photo;
    data['parentId'] = parentId;
    data['parentName'] = parentName;
    data['sortOrder'] = sortOrder;
    return data;
  }
}
