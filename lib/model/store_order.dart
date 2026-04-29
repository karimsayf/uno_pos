class StoreOrder {
  final String? id;
  final StoreOrderUser? user;
  final String? userId;
  final List<StoreOrderItem>? items;
  final double? total;
  final double? shippingAmount;
  final double? adminCommission;
  final double? distanceKm;
  final String? status;
  final String? paymentMethod;
  final String? createdDate;
  final String? note;
  final String? orderNumber;
  final double? subTotal;
  final String? promoCodeUsed;
  final double? promoCodeDiscountAmount;
  final double? totalAmountAfterDiscount;
  final String? customerName;
  final String? customerPhone;
  final String? customerCity;
  final String? customerAddress;
  final String? customerGovernorate;
  final String? merchantPhoto;
  final String? merchantName;
  final String? merchantNumber;
  final String? merchantPhone;
  final String? merchantAddress;
  final String? merchantGovernorate;
  final String? driverName;
  final String? driverPhone;
  final double? pickupLongitude;
  final double? pickupLatitude;
  final double? dropLongitude;
  final double? dropLatitude;

  StoreOrder({
    this.id,
    this.user,
    this.userId,
    this.items,
    this.total,
    this.shippingAmount,
    this.distanceKm,
    this.status,
    this.paymentMethod,
    this.createdDate,
    this.adminCommission,
    this.note,
    this.orderNumber,
    this.subTotal,
    this.promoCodeUsed,
    this.promoCodeDiscountAmount,
    this.totalAmountAfterDiscount,
    this.customerName,
    this.customerPhone,
    this.customerCity,
    this.customerAddress,
    this.customerGovernorate,
    this.merchantPhoto,
    this.merchantName,
    this.merchantNumber,
    this.merchantPhone,
    this.merchantAddress,
    this.merchantGovernorate,
    this.driverName,
    this.driverPhone,
    this.pickupLongitude,
    this.pickupLatitude,
    this.dropLongitude,
    this.dropLatitude,
  });

  factory StoreOrder.fromJson(Map<String, dynamic> json) {
    return StoreOrder(
      id: json['id'],
      user: json['user'] != null ? StoreOrderUser.fromJson(json['user']) : null,
      userId: json['userId'],
      items: json['items'] != null
          ? List<StoreOrderItem>.from(
          json['items'].map((x) => StoreOrderItem.fromJson(x)))
          : [],
      total: (json['total'] as num?)?.toDouble(),
      shippingAmount: (json['shippingAmount'] as num?)?.toDouble(),
      distanceKm: (json['distanceKm'] as num?)?.toDouble(),
      status: json['status'],
      paymentMethod: json['paymentMethod'],
      createdDate: json['createdDate'],
      note: json['note'],
      orderNumber: json['orderNumber'],
      subTotal: (json['subTotal'] as num?)?.toDouble(),
      promoCodeUsed: json['promoCodeUsed'],
      promoCodeDiscountAmount:
      (json['promoCodeDiscountAmount'] as num?)?.toDouble(),
      totalAmountAfterDiscount:
      (json['totalAmountAfterDiscount'] as num?)?.toDouble(),
      adminCommission: (json['adminCommission'] ?? 0).toDouble(),
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      customerCity: json['customerCity'],
      customerAddress: json['customerAddress'],
      customerGovernorate: json['customerGovernorate'],
      merchantPhoto: json['merchantPhoto'],
      merchantName: json['merchantName'],
      merchantNumber: json['merchantNumber'],
      merchantPhone: json['merchantPhone'],
      merchantAddress: json['merchantAddress'],
      merchantGovernorate: json['merchantGovernorate'],
      driverName: json['driverName'],
      driverPhone: json['driverPhone'],
      pickupLongitude: (json['pickupLongitude'] as num?)?.toDouble(),
      pickupLatitude: (json['pickupLatitude'] as num?)?.toDouble(),
      dropLongitude: (json['dropLongitude'] as num?)?.toDouble(),
      dropLatitude: (json['dropLatitude'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user': user?.toJson(),
    'userId': userId,
    'items': items?.map((e) => e.toJson()).toList(),
    'total': total,
    'shippingAmount': shippingAmount,
    'distanceKm': distanceKm,
    'status': status,
    'paymentMethod': paymentMethod,
    'createdDate': createdDate,
    'note': note,
    'orderNumber': orderNumber,
    'subTotal': subTotal,
    'promoCodeUsed': promoCodeUsed,
    'promoCodeDiscountAmount': promoCodeDiscountAmount,
    'totalAmountAfterDiscount': totalAmountAfterDiscount,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerCity': customerCity,
    'customerAddress': customerAddress,
    'customerGovernorate': customerGovernorate,
    'merchantPhoto': merchantPhoto,
    'merchantName': merchantName,
    'merchantNumber': merchantNumber,
    'merchantPhone': merchantPhone,
    'merchantAddress': merchantAddress,
    'merchantGovernorate': merchantGovernorate,
    'driverName': driverName,
    'driverPhone': driverPhone,
    'pickupLongitude': pickupLongitude,
    'pickupLatitude': pickupLatitude,
    'dropLongitude': dropLongitude,
    'dropLatitude': dropLatitude,
  };
}

class StoreOrderUser {
  final String? id;
  final String? username;
  final String? phone;
  final List<String>? roles;
  final String? token;
  final String? photo;

  StoreOrderUser({
    this.id,
    this.username,
    this.phone,
    this.roles,
    this.token,
    this.photo,
  });

  factory StoreOrderUser.fromJson(Map<String, dynamic> json) {
    return StoreOrderUser(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      roles: json['roles'] != null
          ? List<String>.from(json['roles'])
          : [],
      token: json['token'],
      photo: json['photo'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'phone': phone,
    'roles': roles,
    'token': token,
    'photo': photo,
  };
}

class StoreOrderItem {
  final String? id;
  final StoreOrderProduct? item;
  final String? itemId;
  final int? quantity;

  StoreOrderItem({
    this.id,
    this.item,
    this.itemId,
    this.quantity,
  });

  factory StoreOrderItem.fromJson(Map<String, dynamic> json) {
    return StoreOrderItem(
      id: json['id'],
      item:
      json['itemShop'] != null ? StoreOrderProduct.fromJson(json['itemShop']) : null,
      itemId: json['itemId'],
      quantity: json['quantity'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'item': item?.toJson(),
    'itemId': itemId,
    'quantity': quantity,
  };
}

class StoreOrderProduct {
  final String? id;
  final String? name;
  final String? description;
  final double? price;
  final double? finalPrice;
  final String? photo;
  final StoreOrderCategory? category;
  final String? categoryId;
  final StoreOrderMerchant? merchant;
  final String? merchantId;
  final String? merchantName;
  final int? quantity;
  final String? createdDate;
  final bool? favourite;

  StoreOrderProduct({
    this.id,
    this.name,
    this.description,
    this.price,
    this.finalPrice,
    this.photo,
    this.category,
    this.categoryId,
    this.merchant,
    this.merchantId,
    this.merchantName,
    this.quantity,
    this.createdDate,
    this.favourite,
  });

  factory StoreOrderProduct.fromJson(Map<String, dynamic> json) {
    return StoreOrderProduct(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: (json['price'] as num?)?.toDouble(),
      finalPrice: (json['finalPrice'] as num?)?.toDouble(),
      photo: json['photo'],
      category: json['category'] != null
          ? StoreOrderCategory.fromJson(json['category'])
          : null,
      categoryId: json['categoryId'],
      merchant: json['merchant'] != null
          ? StoreOrderMerchant.fromJson(json['merchant'])
          : null,
      merchantId: json['merchantId'],
      merchantName: json['merchantName'],
      quantity: json['quantity'],
      createdDate: json['createdDate'],
      favourite: json['favourite'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'price': price,
    'finalPrice': finalPrice,
    'photo': photo,
    'category': category?.toJson(),
    'categoryId': categoryId,
    'merchant': merchant?.toJson(),
    'merchantId': merchantId,
    'merchantName': merchantName,
    'quantity': quantity,
    'createdDate': createdDate,
    'favourite': favourite,
  };
}

class StoreOrderCategory {
  final String? id;
  final String? name;
  final String? photo;
  final String? parentId;
  final String? parentName;

  StoreOrderCategory({
    this.id,
    this.name,
    this.photo,
    this.parentId,
    this.parentName,
  });

  factory StoreOrderCategory.fromJson(Map<String, dynamic> json) {
    return StoreOrderCategory(
      id: json['id'],
      name: json['name'],
      photo: json['photo'],
      parentId: json['parentId'],
      parentName: json['parentName'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'photo': photo,
    'parentId': parentId,
    'parentName': parentName,
  };
}

class StoreOrderMerchant {
  final String? id;
  final String? username;
  final String? phone;
  final String? logo;
  final String? name;
  final String? createdDate;
  final String? merchantTypeId;
  final String? merchantTypeName;
  final String? merchantCity;
  final String? merchantAddress;
  final String? token;
  final int? visitLog;
  final String? status;
  final int? orderNumber;
  final String? governorate;
  final double? longitude;
  final double? latitude;
  final String? address;
  final String? city;
  final bool? active;
  final String? description;
  final String? cover;

  StoreOrderMerchant({
    this.id,
    this.username,
    this.phone,
    this.logo,
    this.name,
    this.createdDate,
    this.merchantTypeId,
    this.merchantTypeName,
    this.merchantCity,
    this.merchantAddress,
    this.token,
    this.visitLog,
    this.status,
    this.orderNumber,
    this.governorate,
    this.longitude,
    this.latitude,
    this.address,
    this.city,
    this.active,
    this.description,
    this.cover,
  });

  factory StoreOrderMerchant.fromJson(Map<String, dynamic> json) {
    return StoreOrderMerchant(
      id: json['id'],
      username: json['username'],
      phone: json['phone'],
      logo: json['logo'],
      name: json['name'],
      createdDate: json['createdDate'],
      merchantTypeId: json['merchantTypeId'],
      merchantTypeName: json['merchantTypeName'],
      merchantCity: json['merchantCity'],
      merchantAddress: json['merchantAddress'],
      token: json['token'],
      visitLog: json['visitLog'],
      status: json['status'],
      orderNumber: json['orderNumber'],
      governorate: json['governorate'],
      longitude: (json['longitude'] as num?)?.toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble(),
      address: json['address'],
      city: json['city'],
      active: json['active'],
      description: json['description'],
      cover: json['cover'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'phone': phone,
    'logo': logo,
    'name': name,
    'createdDate': createdDate,
    'merchantTypeId': merchantTypeId,
    'merchantTypeName': merchantTypeName,
    'merchantCity': merchantCity,
    'merchantAddress': merchantAddress,
    'token': token,
    'visitLog': visitLog,
    'status': status,
    'orderNumber': orderNumber,
    'governorate': governorate,
    'longitude': longitude,
    'latitude': latitude,
    'address': address,
    'city': city,
    'active': active,
    'description': description,
    'cover': cover,
  };
}

