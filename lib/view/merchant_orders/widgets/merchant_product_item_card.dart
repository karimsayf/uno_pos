import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/restaurant_product_model.dart';
import '../../../utilities/api_urls.dart';
import '../../../utilities/colors.dart';

class MerchantProductItemCard extends StatelessWidget {
  final RestaurantProductModel product;
  final Function(bool) onToggleVisibility;

  const MerchantProductItemCard({
    super.key,
    required this.product,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: colorEEE),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: color5F5,
              image: product.image != null
                  ? DecorationImage(
                      image: NetworkImage(ServerUrls.filesBaseUrl + product.image!),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: product.image == null
                ? const Icon(Icons.fastfood, color: colorCCC, size: 40)
                : null,
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name ?? '',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: black,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Text(
                  '${product.price?.toStringAsFixed(0) ?? 0} د.ع',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: mainColor,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              const Text(
                'عرض',
                style: TextStyle(fontSize: 12, color: colorC9C),
              ),
              const SizedBox(height: 4),
              CupertinoSwitch(
                value: !(product.hide ?? false),
                activeColor: mainColor,
                onChanged: (value) => onToggleVisibility(!value),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
