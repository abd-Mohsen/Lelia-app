// show 3 tabs, one for latest, one to view all subordinates, and one for profile and settings
// page to generate excel file (according to date and other things)

//
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/constants.dart';
import 'package:lelia/controllers/supervisor_controller.dart';

import '../controllers/theme_controller.dart';
import '../models/report_model.dart';
import 'components/report_card.dart';

class SupervisorView extends StatelessWidget {
  const SupervisorView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;
    ThemeController tC = Get.find();
    SupervisorController sC = Get.put(SupervisorController());
    //todo: implement search for users and reports (bottomsheet with dropdownsearch)

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
                  Icons.print_outlined,
                  color: cs.onPrimary,
                  size: 25,
                ),
                child: Text("تصدير التقارير", style: tt.bodyLarge!.copyWith(color: cs.onPrimary)),
              ),
            ],
          ),
          backgroundColor: cs.primary,
        ),
        body: GetBuilder<SupervisorController>(builder: (con) {
          List<ReportModel> allReports = con.reports;
          // List<ReportModel> notUploaded = con.reports.where((report) => report.uploaded!).toList();
          return TabBarView(
            children: [
              ListView.builder(
                itemCount: allReports.length,
                itemBuilder: (context, i) => ReportCard(
                  report: allReports[i],
                  local: false,
                  supervisor: true,
                ),
              ),
              Container(
                  // user card then see all user's report
                  ),
              Container(
                  /*
                drop down to select who's report to generate (all, or specific employee)
                select date
                select file name
                generate excel file (keep the supervisor name and current date in mind)
                */
                  ),
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
                      return con.isLoadingReports
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SpinKitPianoWave(color: cs.primary),
                            )
                          : UserAccountsDrawerHeader(
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
                          kAboutAppDialog(),
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
