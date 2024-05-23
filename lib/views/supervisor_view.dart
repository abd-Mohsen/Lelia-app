// show 3 tabs, one for latest, one to view all subordinates, and one for profile and settings
// page to generate excel file (according to date and other things)

//
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/supervisor_controller.dart';

import '../controllers/theme_controller.dart';

class SupervisorView extends StatelessWidget {
  const SupervisorView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    ThemeController tC = Get.find();
    SupervisorController sC = Get.put(SupervisorController());

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: cs.background,
        appBar: AppBar(
          title: Text(
            "لوحة تحكم المشرف",
            style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
          ),
          actions: [
            //
          ],
          bottom: TabBar(
            indicatorColor: Colors.deepOrange,
            indicatorWeight: 4,
            tabs: [
              Tab(
                icon: Icon(
                  Icons.checklist_outlined,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text("كل التقارير", style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
              ),
              Tab(
                icon: Icon(
                  Icons.person_outline,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text("المندوبين", style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
              ),
              Tab(
                icon: Icon(
                  Icons.print,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text("تصدير التقارير", style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
              ),
            ],
          ),
          backgroundColor: cs.primary,
        ),
        body: GetBuilder<SuperController>(builder: (con) {
          // List<ReportModel> uploaded = con.reports.where((report) => !report.uploaded!).toList();
          // List<ReportModel> notUploaded = con.reports.where((report) => report.uploaded!).toList();
          return TabBarView(
            children: [
              // ListView.builder(
              //   itemCount: uploaded.length,
              //   itemBuilder: (context, i) => ReportCard(
              //     report: uploaded[i],
              //     local: true,
              //   ),
              // ),
              // ListView.builder(
              //   itemCount: notUploaded.length,
              //   itemBuilder: (context, i) => ReportCard(
              //     report: notUploaded[i],
              //     local: true,
              //   ),
              // ),
              Container(),
              Container(),
              Container(),
            ],
          );
        }),
        drawer: Drawer(
          backgroundColor: cs.background,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    GetBuilder<SupervisorController>(builder: (con) {
                      return con.isLoading
                          ? SpinKitPianoWave(color: cs.primary)
                          : UserAccountsDrawerHeader(
                              //todo: showing old data or not showing at all, add loading
                              // decoration: BoxDecoration(
                              //   color: cs.primary,
                              // ),
                              accountName: Text(
                                con.currentUser?.userName ?? "",
                                style: tt.headlineMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                              accountEmail: Text(
                                con.currentUser?.email ?? "",
                                style: tt.titleMedium,
                                overflow: TextOverflow.ellipsis,
                              ),
                            );
                    }),
                    ListTile(
                      leading: const Icon(Icons.dark_mode_outlined),
                      title: Text("الوضع الداكن", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
                      trailing: Switch(
                        value: tC.switchValue,
                        onChanged: (bool value) {
                          tC.updateTheme(value);
                        },
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: Text("حول التطبيق", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
                      onTap: () {
                        Get.dialog(
                          AlertDialog(
                            icon: Icon(
                              Icons.info_outline,
                              color: cs.primary,
                              size: 35,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(
                                  "ok",
                                  style: tt.titleMedium?.copyWith(color: cs.primary),
                                ),
                              ),
                            ],
                            content: Column(
                              children: [
                                Scrollbar(
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            "تم تطوير هذا البرنامج لصالح شركة ليتيا المغفلة الخاصة, جميع الحقوق محفوظة",
                                            style: tt.headlineSmall!.copyWith(color: cs.onSurface),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                    ListTile(
                      leading: Icon(Icons.logout, color: cs.error),
                      title: Text("تسجيل خروج", style: tt.titleMedium!.copyWith(color: cs.error)),
                      onTap: () {
                        sC.logout();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'جميع الحقوق محفوظة',
                  style: tt.labelMedium!.copyWith(color: cs.onSurface.withOpacity(0.6)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
