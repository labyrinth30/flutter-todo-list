class Order {
  int? value;
  String? label;
  Order({
    this.value,
    this.label,
  });
}

List<Order> orders = [
  Order(value: 0, label: "정렬 순서"),
  Order(value: 1, label: "가나다 오름차순"),
  Order(value: 2, label: "가나다 내림차순"),
  Order(value: 3, label: "완료 여부"),
];
