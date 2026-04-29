
import 'package:yosr_pos/model/cart_meal_model.dart';

class RestaurantOrder {
  final String id;
  final String orderNumber;
  final String orderNum;
  final String customerId;
  final String restaurantId;
  final String restaurantName;
  final String restaurantPhone;
  final String restaurantLogo;
  final String restaurantAddress;

  final String customerName;
  final String customerPhone;
  final String customerAddress;
  final String customerCity;

  final String status;
  final String paymentMethod;
  final String paymentStatus;
  final String deliveryType;

  final String deliveryAddress;
  final String phone;
  final String notes;

  final double? adminCommission;
  final double subtotal;
  final double deliveryFee;
  final double total;
  final int numberOfItems;
  final int ageSeconds;

  final double restaurantLat;
  final double restaurantLng;
  final double distanceKm;

  final List<CartMealModel> items;

  final int etaMinutes;
  final int remainingMinutes;
  final DateTime? expectedArrivalAt;
  final DateTime? createdAt;
  final String? encodedPolyLines;

  const RestaurantOrder({
    required this.id,
    required this.orderNumber,
    required this.orderNum,
    required this.customerId,
    required this.restaurantId,
    required this.restaurantName,
    required this.restaurantPhone,
    required this.restaurantLogo,
    required this.restaurantAddress,
    required this.customerName,
    required this.customerPhone,
    this.adminCommission,
    required this.customerAddress,
    required this.customerCity,
    required this.status,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.deliveryType,
    required this.deliveryAddress,
    required this.phone,
    required this.notes,
    required this.subtotal,
    required this.deliveryFee,
    required this.total,
    required this.numberOfItems,
    required this.ageSeconds,
    required this.restaurantLat,
    required this.restaurantLng,
    required this.distanceKm,
    required this.items,
    required this.etaMinutes,
    required this.remainingMinutes,
    required this.expectedArrivalAt,
    required this.createdAt,
    required this.encodedPolyLines
  });

  factory RestaurantOrder.fromJson(Map<String, dynamic> json) {
    return RestaurantOrder(
      id: (json['id'] ?? '').toString(),
      orderNumber: (json['orderNumber'] ?? '').toString(),
      orderNum: (json['orderNum'] ?? '').toString(),
      customerId: (json['customerId'] ?? '').toString(),
      restaurantId: (json['restaurantId'] ?? '').toString(),
      restaurantName: (json['restaurantName'] ?? '').toString(),
      restaurantPhone: (json['restaurantPhone'] ?? '').toString(),
      restaurantLogo: (json['restaurantLogo'] ?? '').toString(),
      restaurantAddress: (json['restaurantAddress'] ?? '').toString(),
      customerName: (json['customerName'] ?? '').toString(),
      customerPhone: (json['customerPhone'] ?? '').toString(),
      customerAddress: (json['customerAddress'] ?? '').toString(),
      customerCity: (json['customerCity'] ?? '').toString(),
      status: json['status'] ??'',
      paymentMethod: json['paymentMethod']??'',
      paymentStatus:json['paymentStatus']??'',
      deliveryType: json['deliveryType']??'',
      deliveryAddress: (json['deliveryAddress'] ?? '').toString(),
      phone: (json['phone'] ?? '').toString(),
      notes: (json['notes'] ?? '').toString(),
      subtotal: json['subtotal']??0,
      deliveryFee: json['deliveryFee']??0,
      total:json['total']??0,
      numberOfItems: json['numberOfItems']??0,
      ageSeconds: json['ageSeconds']??0,
      restaurantLat: json['restaurantLat']??0,
      restaurantLng: json['restaurantLng']??0,
      distanceKm: json['distanceKm']??0,
      items: (json['items'] as List? ?? const [])
          .map((e) => CartMealModel.fromOrderJson(Map<String, dynamic>.from(e as Map)))
          .toList(),
      etaMinutes: json['etaMinutes']??0,
      remainingMinutes: json['remainingMinutes']??0,
      expectedArrivalAt: DateTime.tryParse(json['expectedArrivalAt']??'') ??DateTime.now(),
      createdAt:  DateTime.tryParse(json['createdAt']??'') ??DateTime.now(),
      encodedPolyLines: json['encodedPolyLines']??'',
      adminCommission: (json['adminCommission'] ?? 0).toDouble(),

    );
  }
 }