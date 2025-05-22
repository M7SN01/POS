import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import '../../../widget/widgest.dart';
import '../../controller/invoice_controller.dart';

class LeftCard extends StatelessWidget {
  const LeftCard({super.key});

  totalsView({required String name, required double value}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: Text(
              name.tr,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          // const SizedBox(width: 5),
          Expanded(
            child: Center(
              child: Text(
                "$value",
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          // const Spacer(),
          Expanded(
            child: SvgPicture.asset(
              'assets/images/rs.svg',
              height: 20,
              width: 20,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<MainInvoiceController>(builder: (controller) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              const SizedBox(height: 20),
              totalsView(name: 'total', value: controller.sumOfSubtotal(controller.invoiceItems)),
              /*double.parse(controller.invoiceItems.fold(0.0, (sum, item) => sum + (item.price * item.qty)).toStringAsFixed(2))
              */
              const SizedBox(height: 5),
              const DashedLine(),
              const SizedBox(height: 5),
              totalsView(
                name: 'total_discount',
                value: controller.sumOfDiscount(controller.invoiceItems) /*double.parse(controller.invoiceItems.fold(0.0, (sum, item) => sum + (item.discount)).toStringAsFixed(2))*/,
              ),
              const SizedBox(height: 5),
              const DashedLine(),
              const SizedBox(height: 5),
              totalsView(
                name: 'total_price_after_discount',
                value: controller.sumPriceAfterDiscount(controller.invoiceItems) /*double.parse(controller.invoiceItems.fold(0.0, (sum, item) => sum + ((item.price * item.qty) - item.discount)).toStringAsFixed(2))*/,
              ),
              const SizedBox(height: 5),
              const DashedLine(),
              const SizedBox(height: 5),
              totalsView(name: 'total_tax', value: controller.sumOfTax(controller.invoiceItems) /*double.parse(controller.invoiceItems.fold(0.0, (sum, item) => sum + (((item.price * item.qty) - item.discount) * 0.15)).toStringAsFixed(2))*/),
              const SizedBox(height: 5),
              const DashedLine(),
              const SizedBox(height: 5),
              totalsView(
                name: 'total_price_after_tax',
                value: controller.sumPriceAfterTax(controller.invoiceItems) /*double.parse(controller.invoiceItems.fold(0.0, (sum, item) => sum + ((item.price * item.qty - item.discount) * 1.15)).toStringAsFixed(2))*/,
              ),
              const SizedBox(height: 5),
              const DashedLine(
                cropSide: true,
              ),
              const SizedBox(height: 5),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    backgroundColor: const Color(0xFF58be45),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'payment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}
