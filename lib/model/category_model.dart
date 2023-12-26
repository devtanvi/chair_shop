class DataModel {
  int success;
  Data data;

  DataModel({required this.success, required this.data});

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      success: json['success'],
      data: Data.fromJson(json['Data']),
    );
  }
}

class Data {
  String currentTimestamp;
  List<Banner> banner;
  List<Category> categories;
  String bodykitBanner;
  List<HomeBnr> homeBnr;
  List<CarMustHave> carMustHave;
  List<Gst> gst;

  Data({
    required this.currentTimestamp,
    required this.banner,
    required this.categories,
    required this.bodykitBanner,
    required this.homeBnr,
    required this.carMustHave,
    required this.gst,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      currentTimestamp: json['current_timestamp'],
      banner: List<Banner>.from(json['banner'].map((x) => Banner.fromJson(x))),
      categories: List<Category>.from(json['categories'].map((x) => Category.fromJson(x))),
      bodykitBanner: json['bodykit_banner'],
      homeBnr: List<HomeBnr>.from(json['home_bnr'].map((x) => HomeBnr.fromJson(x))),
      carMustHave: List<CarMustHave>.from(json['car_must_have'].map((x) => CarMustHave.fromJson(x))),
      gst: List<Gst>.from(json['gst'].map((x) => Gst.fromJson(x))),
    );
  }
}

class Banner {
  String id;
  String moduleId;
  String url;
  String position;
  String image;
  String status;
  String homesliderId;
  String languageId;
  String title;
  String caption;
  String description;

  Banner({
    required this.id,
    required this.moduleId,
    required this.url,
    required this.position,
    required this.image,
    required this.status,
    required this.homesliderId,
    required this.languageId,
    required this.title,
    required this.caption,
    required this.description,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      id: json['id'],
      moduleId: json['module_id'],
      url: json['url'],
      position: json['position'],
      image: json['image'],
      status: json['status'],
      homesliderId: json['homeslider_id'],
      languageId: json['language_id'],
      title: json['title'],
      caption: json['caption'],
      description: json['description'],
    );
  }
}

class Category {
  String name;
  String image;
  String categoryId;

  Category({
    required this.name,
    required this.image,
    required this.categoryId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      name: json['name'],
      image: json['image'],
      categoryId: json['category_id'],
    );
  }
}

class HomeBnr {
  String image;
  String categoryId;
  String title;

  HomeBnr({
    required this.image,
    required this.categoryId,
    required this.title,
  });

  factory HomeBnr.fromJson(Map<String, dynamic> json) {
    return HomeBnr(
      image: json['image'],
      categoryId: json['category_id'],
      title: json['title'],
    );
  }
}

class CarMustHave {
  String name;
  String image;
  String des;
  String categoryId;

  CarMustHave({
    required this.name,
    required this.image,
    required this.des,
    required this.categoryId,
  });

  factory CarMustHave.fromJson(Map<String, dynamic> json) {
    return CarMustHave(
      name: json['name'],
      image: json['image'],
      des: json['des'],
      categoryId: json['category_id'],
    );
  }
}

class Gst {
  String taxClassId;
  String title;
  String rate;

  Gst({
    required this.taxClassId,
    required this.title,
    required this.rate,
  });

  factory Gst.fromJson(Map<String, dynamic> json) {
    return Gst(
      taxClassId: json['tax_class_id'],
      title: json['title'],
      rate: json['rate'],
    );
  }
}
