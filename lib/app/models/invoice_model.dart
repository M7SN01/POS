class InvoiceItem {
  final String id;
  final String barcode;
  final String name;
  final double price;
  final double discount;
  String? calss_1;
  double qty;
  String? imageUrl;

  InvoiceItem({
    required this.id,
    required this.barcode,
    required this.name,
    required this.price,
    required this.discount,
    required this.calss_1,
    this.qty = 1,
    this.imageUrl,
  });

  double get total => (price * qty) - discount;
}
