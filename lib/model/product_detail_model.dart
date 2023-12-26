class ProductDetail {
  final int success;
  final ProductData data;

  ProductDetail({
    required this.success,
    required this.data,
  });

  factory ProductDetail.fromJson(Map<String, dynamic> json) {
    return ProductDetail(
      success: json['success'] ?? 0,
      data: ProductData.fromJson(json['Data'] ?? {}),
    );
  }
}

class ProductData {
  final String productId;
  final String model;
  final String sku;
  final String upc;
  final String ean;
  final String jan;
  final String isbn;
  final String mpn;
  final String location;
  int quantity;
  final String stockStatusId;
  final String image;
  final String manufacturerId;
  final String shipping;
  final String price;
  final String originalPrice;
  final String points;
  final String taxClassId;
  final String dateAvailable;
  final String weight;
  final String weightCharge;
  final String weightClassId;
  final String length;
  final String width;
  final String height;
  final String lengthClassId;
  final String subtract;
  final String minimum;
  final String sortOrder;
  final String status;
  final String viewed;
  final String dateAdded;
  final String dateModified;
  final String? lookbookId;
  final String name;
  final String description;
  final String specialPrice;
  final String productSpecial;
  final List<ProductImage> images;
  final List<ProductAttribute> attribute;
  final List<dynamic> options;

  ProductData({
    required this.productId,
    required this.model,
    required this.sku,
    required this.upc,
    required this.ean,
    required this.jan,
    required this.isbn,
    required this.mpn,
    required this.location,
    required this.quantity,
    required this.stockStatusId,
    required this.image,
    required this.manufacturerId,
    required this.shipping,
    required this.price,
    required this.originalPrice,
    required this.points,
    required this.taxClassId,
    required this.dateAvailable,
    required this.weight,
    required this.weightCharge,
    required this.weightClassId,
    required this.length,
    required this.width,
    required this.height,
    required this.lengthClassId,
    required this.subtract,
    required this.minimum,
    required this.sortOrder,
    required this.status,
    required this.viewed,
    required this.dateAdded,
    required this.dateModified,
    this.lookbookId,
    required this.name,
    required this.description,
    required this.specialPrice,
    required this.productSpecial,
    required this.images,
    required this.attribute,
    required this.options,
  });

  factory ProductData.fromJson(Map<String, dynamic> json) {
    final List<ProductImage> images = (json['images'] as List<dynamic>? ?? [])
        .map((item) => ProductImage.fromJson(item))
        .toList();
    final List<ProductAttribute> attribute =
        (json['attribute'] as List<dynamic>? ?? [])
            .map((item) => ProductAttribute.fromJson(item))
            .toList();
    int quantity = 1;
    final dynamic quantityValue = json['quantity'];
    if (quantityValue is int) {
      quantity = quantityValue;
    }

    return ProductData(
      productId: json['product_id'] ?? "",
      model: json['model'] ?? "",
      sku: json['sku'] ?? "",
      upc: json['upc'] ?? "",
      ean: json['ean'] ?? "",
      jan: json['jan'] ?? "",
      isbn: json['isbn'] ?? "",
      mpn: json['mpn'] ?? "",
      location: json['location'] ?? "",
      quantity: quantity,
      stockStatusId: json['stock_status_id'] ?? "",
      image: json['image'] ?? "",
      manufacturerId: json['manufacturer_id'] ?? "",
      shipping: json['shipping'] ?? "",
      price: json['price'] ?? "",
      originalPrice: json['original_price'] ?? "",
      points: json['points'] ?? "",
      taxClassId: json['tax_class_id'] ?? "",
      dateAvailable: json['date_available'] ?? "",
      weight: json['weight'] ?? "",
      weightCharge: json['weight_charge'] ?? "",
      weightClassId: json['weight_class_id'] ?? "",
      length: json['length'] ?? "",
      width: json['width'] ?? "",
      height: json['height'] ?? "",
      lengthClassId: json['length_class_id'] ?? "",
      subtract: json['subtract'] ?? "",
      minimum: json['minimum'] ?? "",
      sortOrder: json['sort_order'] ?? "",
      status: json['status'] ?? "",
      viewed: json['viewed'] ?? "",
      dateAdded: json['date_added'] ?? "",
      dateModified: json['date_modified'] ?? "",
      lookbookId: json['lookbook_id'],
      name: json['name'] ?? "",
      description: json['description'] ?? "",
      specialPrice: json['special_price'] ?? "",
      productSpecial: json['product_special'] ?? "",
      images: images,
      attribute: attribute,
      options: json['options'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "model": model,
      "sku": sku,
      "upc": upc,
      "ean": ean,
      "jan": jan,
      "isbn": isbn,
      "mpn": mpn,
      "location": location,
      "quantity": quantity,
      "stock_status_id": stockStatusId,
      "image": image,
      "manufacturer_id": manufacturerId,
      "shipping": shipping,
      "price": price,
      "original_price": originalPrice,
      "points": points,
      "tax_class_id": taxClassId,
      "date_available": dateAvailable,
      "weight": weight,
      "weight_charge": weightCharge,
      "weight_class_id": weightClassId,
      "length": length,
      "width": width,
      "height": height,
      "length_class_id": lengthClassId,
      "subtract": subtract,
      "minimum": minimum,
      "sort_order": sortOrder,
      "status": status,
      "viewed": viewed,
      "date_added": dateAdded,
      "date_modified": dateModified,
      "lookbook_id": lookbookId,
      "name": name,
      "description": description,
      "special_price": specialPrice,
      "product_special": productSpecial,
      "images": images.map((image) => image.toJson()).toList(),
      "attribute": attribute.map((attr) => attr.toJson()).toList(),
      "options": options,
    };
  }

  void updateQuantity(int newQuantity) {
    quantity = newQuantity;
  }
}

class ProductImage {
  final String image;

  ProductImage({
    required this.image,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      image: json['image'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "image": image,
    };
  }
}

class ProductAttribute {
  final String text;
  final String name;

  ProductAttribute({
    required this.text,
    required this.name,
  });

  factory ProductAttribute.fromJson(Map<String, dynamic> json) {
    return ProductAttribute(
      text: json['text'] ?? "",
      name: json['name'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "text": text,
      "name": name,
    };
  }
}
