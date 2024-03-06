import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/home_controller.dart';
import 'package:lelia/controllers/theme_controller.dart';
import 'package:lelia/views/components/custom_dropdown.dart';
import 'package:lelia/views/components/custom_field.dart';
import 'package:lelia/views/login_view.dart';
import 'package:lelia/views/map_page.dart';
import 'package:lelia/views/reports_view.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    HomeController hC = Get.put(HomeController());
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'Letia',
          style: tt.headlineMedium!.copyWith(letterSpacing: 5, color: cs.onPrimary),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              hC.clearReport();
            },
            icon: Icon(Icons.restart_alt),
          )
        ],
      ),
      backgroundColor: cs.background,
      body: GetBuilder<HomeController>(
        //init: HomeController(),
        builder: (con) => Form(
          key: con.dataFormKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
              // todo: add constraints for fields
              CustomField(
                controller: con.name,
                iconData: Icons.label,
                hint: "اسم النقطة",
                validator: (s) {
                  return validateInput(s!, 0, 1100, "name");
                },
                onChanged: (s) {
                  if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                },
              ),
              CustomDropdown(
                icon: Icons.store,
                title: "نوع النقطة",
                items: const [
                  "بائع جملة",
                  "مركز تجاري (مول)",
                  "صيدلية",
                  "بقالية",
                ],
                onSelect: (String? newVal) {
                  con.setType(newVal!);
                },
                selectedValue: con.type,
              ),
              CustomDropdown(
                icon: Icons.photo_size_select_small_sharp,
                title: "حجم النقطة",
                items: const [
                  "صغير",
                  "وسط",
                  "كبير",
                ],
                onSelect: (String? newVal) {
                  con.setSize(newVal!);
                },
                selectedValue: con.size,
              ),
              Row(
                children: [
                  Expanded(
                    child: CustomField(
                      controller: con.street,
                      iconData: Icons.location_pin,
                      hint: "اسم الحي",
                      validator: (s) {
                        return validateInput(s!, 0, 1100, "name");
                      },
                      onChanged: (s) {
                        if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomField(
                      controller: con.neighborhood,
                      iconData: Icons.location_pin,
                      hint: "اسم الشارع",
                      validator: (s) {
                        return validateInput(s!, 0, 1100, "name");
                      },
                      onChanged: (s) {
                        if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                      },
                    ),
                  ),
                ],
              ),
              CustomField(
                controller: con.phone,
                iconData: Icons.phone,
                keyboard: TextInputType.number,
                hint: "هاتف أرضي",
                validator: (s) {
                  return validateInput(s!, 0, 1100, "name");
                },
                onChanged: (s) {
                  if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                },
              ),
              CustomField(
                controller: con.mobilePhone,
                iconData: Icons.phone_android,
                keyboard: TextInputType.number,
                hint: "موبايل",
                validator: (s) {
                  return validateInput(s!, 0, 1100, "name");
                },
                onChanged: (s) {
                  if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: CheckboxListTile(
                  value: con.available,
                  onChanged: (val) {
                    con.toggleAvailability(val!);
                  },
                  checkColor: cs.onPrimary,
                  activeColor: cs.primary,
                  title: Text(
                    "التواجد",
                    style: tt.titleLarge!.copyWith(color: cs.onBackground),
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: cs.onBackground.withOpacity(0.6)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Visibility(
                visible: con.available,
                child: CustomDropdown(
                  icon: Icons.shopping_cart,
                  title: "حركة المنتج",
                  items: const [
                    "سريعة",
                    "جيدة",
                    "بطيئة",
                  ],
                  onSelect: (String? newVal) {
                    con.setStatus(newVal!);
                  },
                  selectedValue: con.status,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  leading: Icon(Icons.location_searching, size: 30, color: cs.primary),
                  title: Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      "احداثيات النقطة",
                      style: tt.titleLarge!.copyWith(
                        color: cs.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ),
                  trailing: con.isLoading
                      ? CircularProgressIndicator()
                      : con.position == null
                          ? const Icon(Icons.dangerous_outlined, color: Colors.red, size: 35)
                          : const Icon(Icons.task_alt, color: Colors.green, size: 35),
                  subtitle: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            con.getLocation(context);
                          },
                          child: Text(
                            'حفظ',
                            style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
                          ),
                        ),
                        SizedBox(width: 12),
                        Visibility(
                          visible: con.position != null,
                          //todo: fix map error in console
                          child: ElevatedButton(
                            onPressed: () {
                              // showModalBottomSheet(
                              //   context: context,
                              //   builder: (context) => SizedBox(
                              //     child: OSMFlutter(
                              //         controller: MapController.withPosition(
                              //           initPosition: GeoPoint(
                              //             latitude: con.position!.latitude,
                              //             longitude: con.position!.longitude,
                              //           ),
                              //         ),
                              //         osmOption: OSMOption(
                              //           // userTrackingOption: UserTrackingOption(
                              //           //   enableTracking: true,
                              //           //   unFollowUser: false,
                              //           // ),
                              //           zoomOption: const ZoomOption(
                              //             initZoom: 20,
                              //             minZoomLevel: 3,
                              //             maxZoomLevel: 19,
                              //             stepZoom: 1.0,
                              //           ),
                              //           // userLocationMarker: UserLocationMaker(
                              //           //   personMarker: MarkerIcon(
                              //           //     icon: Icon(
                              //           //       Icons.location_history_rounded,
                              //           //       color: Colors.red,
                              //           //       size: 48,
                              //           //     ),
                              //           //   ),
                              //           //   directionArrowMarker: MarkerIcon(
                              //           //     icon: Icon(
                              //           //       Icons.double_arrow,
                              //           //       size: 48,
                              //           //     ),
                              //           //   ),
                              //           // ),
                              //           roadConfiguration: const RoadOption(
                              //             roadColor: Colors.yellowAccent,
                              //           ),
                              //           markerOption: MarkerOption(
                              //               defaultMarker: const MarkerIcon(
                              //             icon: Icon(
                              //               Icons.person_pin_circle,
                              //               color: Colors.blue,
                              //               size: 56,
                              //             ),
                              //           )),
                              //         )),
                              //   ),
                              // );
                              //
                              Get.to(
                                MapPage(
                                  latitude: con.position!.latitude,
                                  longitude: con.position!.longitude,
                                ),
                              );
                            },
                            child: Text(
                              'معاينة',
                              style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(width: 1, color: cs.onBackground.withOpacity(0.6)),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              CustomField(
                controller: con.notes,
                //iconData: Icons.note_alt_sharp,
                hint: "ملاحظات الزبون",
                lines: 4,
                validator: (s) {
                  return validateInput(s!, 0, 1100, "");
                },
                onChanged: (s) {
                  if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0, bottom: 4),
                child: ElevatedButton(
                  onPressed: () {
                    con.submit();
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'حفظ في الذاكرة',
                          style: tt.headlineSmall!.copyWith(color: cs.onPrimary, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 12),
                        Icon(Icons.save_alt, size: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: cs.background,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: cs.primary,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Icon(
                    Icons.person_2,
                    color: cs.onPrimary,
                    size: 60,
                  ),
                  SizedBox(width: 24),
                  Text(
                    "name",
                    overflow: TextOverflow.ellipsis,
                    style: tt.headlineLarge!.copyWith(color: cs.onPrimary),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: Icon(Icons.dark_mode_outlined),
              title: Text("الوضع الداكن", style: tt.titleLarge!.copyWith(color: cs.onBackground)),
              trailing: Switch(
                value: tC.switchValue,
                onChanged: (bool value) {
                  tC.updateTheme(value);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.mobile_friendly),
              title: Text("التقارير المحفوظة", style: tt.titleLarge!.copyWith(color: cs.onBackground)),
              onTap: () {
                Get.to(() => ReportsView());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text("تسجيل خروج", style: tt.titleLarge!.copyWith(color: cs.error)),
              onTap: () {
                Get.offAll(() => const LoginView());
              },
            ),
          ],
        ),
      ),
    );
  }
}
