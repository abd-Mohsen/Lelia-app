import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/controllers/supervisor_controller.dart';

class DateSelector extends StatelessWidget {
  final bool start;
  const DateSelector({super.key, required this.start});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    SupervisorController sC = Get.find();

    return GetBuilder<SupervisorController>(
      builder: (con) {
        return Visibility(
          visible: start || con.fromDate != null,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: ListTile(
              onTap: () async {
                DateTime? newDate = await showDatePicker(
                  context: context,
                  initialDate: start
                      ? (con.fromDate == null ? DateTime.now() : con.fromDate!)
                      : (con.toDate == null ? DateTime.now() : con.toDate!),
                  firstDate: start || con.fromDate == null ? DateTime(2002) : con.fromDate!,
                  lastDate: !start || con.toDate == null ? DateTime.now() : con.toDate!,
                  currentDate: start ? sC.fromDate : sC.toDate,
                );
                start ? sC.setFromDate(newDate!) : sC.setToDate(newDate!);
              },
              title: Text(
                start ? "من تاريخ" : "الى تاريخ",
                style: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.6)),
              ),
              //leading: Icon(Icons.date_range),
              trailing: (start ? con.fromDate : con.toDate) != null
                  ? Text(
                      Jiffy.parseFromDateTime(start ? con.fromDate! : con.toDate!).format(pattern: "d / M / y"),
                      style: tt.titleSmall!.copyWith(color: cs.onSurface.withOpacity(0.6)),
                    )
                  : Text(
                      "انقر للاختيار",
                      style: tt.titleSmall!.copyWith(color: cs.primary),
                    ),

              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: cs.onBackground.withOpacity(0.6)),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        );
      },
    );
  }
}
