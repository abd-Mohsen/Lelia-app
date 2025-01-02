import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/report_search_controller.dart';
import 'package:lelia/views/components/custom_field.dart';
import 'package:lelia/views/components/report_card.dart';

class ReportSearchView extends StatelessWidget {
  const ReportSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "بحث عن تقرير",
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        backgroundColor: cs.primary,
      ),
      body: GetBuilder<ReportSearchController>(
          init: ReportSearchController(),
          builder: (controller) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: CustomField(
                    controller: controller.query,
                    hint: "اسم النقطة",
                    onChanged: (s) => controller.performSearch(),
                    validator: (s) => null,
                    iconData: Icons.search,
                  ),
                ),
                Expanded(
                  child: controller.isLoading && controller.searchResult.isEmpty
                      ? SpinKitDualRing(color: cs.primary)
                      : ListView.builder(
                          controller: controller.scrollController,
                          physics: const AlwaysScrollableScrollPhysics(),
                          itemCount: controller.searchResult.length + 1,
                          itemBuilder: (context, i) {
                            if (i < controller.searchResult.length) {
                              return ReportCard(
                                report: controller.searchResult[i],
                                local: false,
                                supervisor: true,
                              );
                            }
                            return Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 24),
                                child: controller.hasMore &&
                                        controller.query.text.isNotEmpty &&
                                        controller.searchResult.isNotEmpty
                                    ? CircularProgressIndicator(color: cs.primary)
                                    : CircleAvatar(
                                        radius: 5,
                                        backgroundColor: Colors.grey.withOpacity(0.7),
                                      ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          }),
    );
  }
}
