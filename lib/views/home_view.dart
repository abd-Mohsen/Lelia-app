import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/home_controller.dart';
import 'package:lelia/controllers/theme_controller.dart';
import 'package:lelia/views/components/custom_dropdown.dart';
import 'package:lelia/views/components/custom_field.dart';
import 'package:lelia/views/map_page.dart';
import 'package:lelia/views/reports_view.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
    HomeController hC = Get.put(HomeController());
    ColorScheme cs = Theme.of(context).colorScheme;
    TextTheme tt = Theme.of(context).textTheme;

    showPickPicSheet() => Get.bottomSheet(
          SizedBox(
            height: 120, //todo: find a way to never overflow
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.camera),
                  title: Text("التقط صورة"),
                  onTap: () {
                    hC.pickImage("camera");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.photo),
                  title: Text("من الاستوديو"),
                  onTap: () {
                    hC.pickImage("gallery");
                  },
                ),
              ],
            ),
          ),
          backgroundColor: cs.surface,
        );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        title: Text(
          'Letia',
          style: tt.headlineMedium!.copyWith(letterSpacing: 2, color: cs.onPrimary),
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
                    style: tt.titleMedium!.copyWith(color: cs.onBackground),
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
                      style: tt.titleMedium!.copyWith(
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
                            style: tt.titleLarge!.copyWith(color: cs.onPrimary),
                          ),
                        ),
                        SizedBox(width: 12),
                        Visibility(
                          visible: con.position != null,
                          //todo: fix map error in console
                          child: ElevatedButton(
                            onPressed: () {
                              Get.to(
                                MapPage(
                                  latitude: con.position!.latitude,
                                  longitude: con.position!.longitude,
                                ),
                              );
                            },
                            child: Text(
                              'معاينة',
                              style: tt.titleLarge!.copyWith(color: cs.onPrimary),
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
                padding: const EdgeInsets.all(8.0),
                child: con.images.isEmpty
                    ? GestureDetector(
                        onTap: () {
                          showPickPicSheet();
                        },
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.grey,
                              width: 1.0,
                            ),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: cs.onBackground,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'اضف صورة',
                                style: tt.titleLarge!.copyWith(
                                  color: cs.onSurface.withOpacity(0.6),
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    : Column(
                        children: [
                          CarouselSlider(
                            items: [
                              ...con.images.map((e) => Image.file(File(e.path))).toList(),
                              GestureDetector(
                                onTap: () {
                                  showPickPicSheet();
                                },
                                child: Container(
                                  //width: 100,
                                  height: 170,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey,
                                      width: 1.0,
                                    ),
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 40,
                                      color: cs.onBackground,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            options: CarouselOptions(
                              enableInfiniteScroll: false,
                              aspectRatio: 4 / 3,
                              onPageChanged: (i, reason) => con.setPicIndex(i),
                            ),
                          ),
                          const SizedBox(height: 8),
                          AnimatedSmoothIndicator(
                            activeIndex: con.picIndex,
                            count: con.images.length + 1,
                            effect: WormEffect(dotHeight: 9, dotWidth: 9, activeDotColor: cs.primary),
                          )
                        ],
                      ),
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
                          style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
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
              title: Text("الوضع الداكن", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
              trailing: Switch(
                value: tC.switchValue,
                onChanged: (bool value) {
                  tC.updateTheme(value);
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.mobile_friendly),
              title: Text("التقارير المحفوظة", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
              onTap: () {
                Get.to(() => ReportsView());
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: cs.error),
              title: Text("تسجيل خروج", style: tt.titleMedium!.copyWith(color: cs.error)),
              onTap: () {
                hC.logout();
              },
            ),
          ],
        ),
      ),
    );
  }
}
