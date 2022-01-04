class AlarmInfo {
  var id;
  var title;
  var alarmDateTime;
  var name;
  var price;
  var limitprice;

  AlarmInfo(
      {this.id,
      this.title,
      this.alarmDateTime,
      this.name,
      this.price,
      this.limitprice});

  factory AlarmInfo.fromMap(Map<String, dynamic> json) => AlarmInfo(
        id: json["id"],
        title: json["title"],
        name: json["name"],
        price: json["price"],
    limitprice: json["limitprice"],
        alarmDateTime: json["alarmDateTime"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "name": name,
        "price": price,
        "limitprice": limitprice,
        "alarmDateTime": alarmDateTime.toIso8601String(),
      };
}
