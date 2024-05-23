// show 3 tabs, one for latest, one to view all subordinates, and one for profile and settings
// page to generate excel file (according to date and other things)

//
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupervisorHomeView extends StatelessWidget {
  const SupervisorHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: cs.background,
        appBar: AppBar(
          title: Text(
            "لوجة تحكم المشرف",
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
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(Icons.arrow_back, color: cs.onPrimary),
          ),
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
              SizedBox(),
              SizedBox(),
              SizedBox(),
            ],
          );
        }),
      ),
    );
  }
}
