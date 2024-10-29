// show 3 tabs, one for latest, one to view all subordinates, and one for profile and settings
// page to generate excel file (according to date and other things)

//
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/constants.dart';
import 'package:lelia/controllers/supervisor_controller.dart';
import 'package:lelia/models/user_model.dart';
import 'package:lelia/views/components/custom_field.dart';
import 'package:lelia/views/components/date_selector.dart';
import 'package:lelia/views/components/user_card.dart';

import '../controllers/theme_controller.dart';
import '../models/report_model.dart';
import 'about_us_page.dart';
import 'components/custom_dropdown.dart';
import 'components/report_card.dart';

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
      child: WillPopScope(
        onWillPop: () async {
          Get.dialog(kCloseAppDialog());
          return false;
        },
        child: Scaffold(
          backgroundColor: cs.background,
          appBar: AppBar(
            title: Text(
              "لوحة تحكم المشرف",
              style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
            ),
            actions: [
              //todo: implement search for users and reports (bottomsheet with dropdownsearch)
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
            List<UserModel> subordinates = con.subordinates;
            List<ReportModel> exportedReports = con.exportedReports;
            return TabBarView(
              children: [
                con.isLoadingReports
                    ? Center(child: SpinKitCubeGrid(color: cs.primary))
                    : RefreshIndicator(
                        onRefresh: con.refreshReports,
                        child: allReports.isEmpty
                            ? ListView(
                                children: [
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(20),
                                      child: Text(
                                        'لا يوجد تقارير بعد, أو هناك مشكلة اتصال\n اسحب للتحديث',
                                        style: tt.titleMedium!.copyWith(color: cs.onSurface),
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
                RefreshIndicator(
                  onRefresh: con.refreshSubordinates,
                  child: con.isLoadingSubs
                      ? Center(child: SpinKitCubeGrid(color: cs.primary))
                      : ListView.builder(
                          itemCount: subordinates.length,
                          itemBuilder: (context, i) => UserCard(
                            user: subordinates[i],
                          ),
                        ),
                ),
                Form(
                  key: con.dataFormKey,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          CustomField(
                            controller: con.fileName,
                            hint: "اسم الملف",
                            iconData: Icons.attach_file,
                            validator: (s) => validateInput(s!, 4, 200, ""),
                            onChanged: (s) {
                              if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                            },
                          ),
                          CustomDropdown(
                            //icon: Icons.person_outline,
                            title: "تصدير من أجل",
                            items: const [
                              "كل المندوبين لدي",
                              "مندوب محدد",
                            ],
                            onSelect: (String? newVal) {
                              con.setGenerateFor(newVal!);
                            },
                            selectedValue: con.generateFor,
                          ),
                          Visibility(
                            visible: con.generateFor == "مندوب محدد",
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0),
                              //todo: list tile borders positions arent updating until i touch the screen
                              //todo: when i change tab, selected user disappears
                              child: DropdownSearch<UserModel>(
                                validator: (user) {
                                  if (user == null && con.generateFor == "مندوب محدد") return "الرجاء اختيار مندوب";
                                  return null;
                                },
                                compareFn: (user1, user2) => user1.id == user2.id,
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    decoration: InputDecoration(
                                      fillColor: Colors.white70,
                                      hintText: "اسم المندوب",
                                      prefix: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Icon(Icons.search, color: cs.onSurface),
                                      ),
                                    ),
                                  ),
                                ),
                                decoratorProps: DropDownDecoratorProps(
                                  decoration: InputDecoration(
                                    labelText: "اسم المندوب",
                                    labelStyle: tt.titleMedium!.copyWith(color: cs.onSurface.withOpacity(0.6)),
                                    //hintText: "اختر اسم المندوب".tr,
                                    // icon: Icon(
                                    //   Icons.text,
                                    //   color: cs.onBackground,
                                    // ),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                items: (filter, infiniteScrollProps) => con.subordinates,
                                itemAsString: (UserModel user) => user.userName,
                                onChanged: (UserModel? user) async {
                                  con.selectSubordinate(user);
                                  await Future.delayed(const Duration(milliseconds: 1000));
                                  if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                                },
                                //enabled: !con.enabled,
                              ),
                            ),
                          ),
                          DateSelector(start: true), // do not put const, it wont be rebuilt
                          DateSelector(start: false),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: GestureDetector(
                              onTap: () {
                                con.export();
                              },
                              child: IntrinsicWidth(
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E7045),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GetBuilder<SupervisorController>(
                                        builder: (con) {
                                          return con.isLoadingExport
                                              ? SpinKitThreeBounce(color: Colors.white, size: 25)
                                              : Text("تصدير ملف إكسل");
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: con.exportedReports.isNotEmpty,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () {
                                  Get.bottomSheet(
                                    Container(
                                      height: MediaQuery.of(context).size.height / 1.5,
                                      color: cs.surface,
                                      child: ListView.builder(
                                        itemCount: exportedReports.length,
                                        itemBuilder: (context, i) => ReportCard(
                                          report: exportedReports[i],
                                          local: false,
                                          supervisor: true,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                child: IntrinsicWidth(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: cs.primary,
                                      borderRadius: BorderRadius.circular(5),
                                    ),
                                    child: const Center(
                                      child: Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text("معاينة التقارير"),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
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
                        return con.isLoadingUser
                            ? Padding(
                                padding: const EdgeInsets.all(24),
                                child: SpinKitPianoWave(color: cs.primary),
                              )
                            : con.currentUser == null
                                ? Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        con.getCurrentUser();
                                      },
                                      style: ButtonStyle(
                                        backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                                      ),
                                      child: Text(
                                        'خطأ, انقر للتحديث',
                                        style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                      ),
                                    ),
                                  )
                                : UserAccountsDrawerHeader(
                                    //showing old data or not showing at all, add loading (is it solved?)
                                    accountName: Text(
                                      con.currentUser!.userName,
                                      style: tt.headlineMedium,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    accountEmail: Text(
                                      con.currentUser!.email,
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
                          Get.to(const AboutUsPage());
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
      ),
    );
  }
}
