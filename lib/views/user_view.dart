import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:lelia/controllers/user_controller.dart';
import 'package:lelia/models/report_model.dart';
import 'package:lelia/views/components/report_card.dart';
import '../models/user_model.dart';

class UserView extends StatelessWidget {
  final UserModel user;
  final bool? supervisor;
  const UserView({super.key, required this.user, this.supervisor});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        title: Text(
          "ملف الموظف",
          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
        ),
        // actions: [
        //   //todo (later): report user (make admin receive a notification of that)
        // ],
        backgroundColor: cs.primary,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: Icon(Icons.arrow_back, color: cs.onPrimary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 16, right: 8, left: 8),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(4),
              child: DottedBorder(
                color: cs.onSurface,
                dashPattern: const [1, 0],
                strokeWidth: 2.0,
                borderType: BorderType.RRect,
                radius: const Radius.circular(10),
                padding: const EdgeInsets.only(right: 8, left: 4, top: 4, bottom: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: Text(
                            user.userName,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            user.email,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            user.phone,
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Text(
                            "انضم في ${Jiffy.parseFromDateTime(user.joinDate).format(pattern: "d / M / y")}",
                            style: tt.titleSmall!.copyWith(color: cs.onSurface),
                            maxLines: 1,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                          child: Text(
                            user.isActivated ? "تم تفعيل حسابه من الشركة" : "الحساب غير مفعل من الشركة",
                            style: tt.titleSmall!.copyWith(color: user.isActivated ? Colors.green : Colors.red),
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Icon(
                          Icons.person,
                          size: 125,
                          color: cs.onSurface,
                        ),
                        Text(
                          user.role,
                          style: tt.titleSmall!.copyWith(color: cs.onSurface),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: user.role == "مندوب مبيعات",
              child: Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 8),
                child: Text(
                  "التقارير المرسلة",
                  style: tt.titleLarge!.copyWith(color: cs.onSurface, decoration: TextDecoration.underline),
                  maxLines: 1,
                ),
              ),
            ),
            GetBuilder<UserController>(
                init: UserController(user: user),
                builder: (con) {
                  List<ReportModel> allReports = con.reports;
                  return Visibility(
                    visible: user.role == "مندوب مبيعات",
                    child: Expanded(
                      child: con.isLoadingReports
                          ? Center(child: SpinKitCubeGrid(color: cs.primary))
                          : RefreshIndicator(
                              onRefresh: con.refreshReports,
                              child: allReports.isEmpty
                                  ? ListView(
                                      children: [
                                        Center(
                                          child: Padding(
                                            padding: const EdgeInsets.all(32),
                                            child: Text(
                                              'لا يوجد تقارير بعد, أو هناك مشكلة اتصال\n اسحب للتحديث',
                                              style: tt.titleSmall!.copyWith(color: cs.onSurface),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : ListView.builder(
                                      controller: con.scrollController,
                                      itemCount: allReports.length + 1,
                                      itemBuilder: (context, i) {
                                        if (i < allReports.length) {
                                          return ReportCard(
                                            report: allReports[i],
                                            local: false,
                                            supervisor: true,
                                          );
                                        }
                                        // Show loading indicator or end-of-list indication
                                        return Center(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 24),
                                            child: con.hasMore
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
                    ),
                  );
                })
          ],
        ),
      ),
    );
  }
}
