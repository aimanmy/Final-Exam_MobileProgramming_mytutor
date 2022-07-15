class Subscription {
  String? subscriptionId;
  String? subjectId;
  String? subjectName;
  String? subjectPrice;
  String? subscriptionQty;
  String? priceTotal;

  Subscription(
      {this.subscriptionId,
      this.subjectId,
      this.subjectName,
      this.subjectPrice,
      this.subscriptionQty,
      this.priceTotal});

  Subscription.fromJson(Map<String, dynamic> json) {
    subscriptionId = json['subscription_id'];
    subjectId = json['subject_id'];
    subjectName = json['subject_name'];
    subjectPrice = json['subject_price'];
    subscriptionQty = json['subscription_qty'];
    priceTotal = json['pricetotal'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['subscription_id'] = subscriptionId;
    data['subject_id'] = subjectId;
    data['subject_name'] = subjectName;
    data['subject_price'] = subjectPrice;
    data['subscription_qty'] = subscriptionQty;
    data['pricetotal'] = priceTotal;
    return data;
  }
}
