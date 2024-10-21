import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:lelia/constants.dart';
import 'package:lelia/controllers/home_controller.dart';
import 'package:lelia/controllers/theme_controller.dart';
import 'package:lelia/views/about_us_page.dart';
import 'package:lelia/views/all_reports_view.dart';
import 'package:lelia/views/components/custom_dropdown.dart';
import 'package:lelia/views/components/custom_field.dart';
import 'package:lelia/views/map_page.dart';
import 'package:lelia/views/local_reports_view.dart';
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
            height: 120, //find a way to never overflow
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.camera,
                    color: cs.onSurface,
                  ),
                  title: Text(
                    "التقط صورة",
                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                  ),
                  onTap: () {
                    hC.pickImage("camera");
                  },
                ),
                ListTile(
                  leading: Icon(
                    Icons.photo,
                    color: cs.onSurface,
                  ),
                  title: Text(
                    "من الاستوديو",
                    style: tt.titleMedium!.copyWith(color: cs.onSurface),
                  ),
                  onTap: () {
                    hC.pickImage("gallery");
                  },
                ),
              ],
            ),
          ),
          backgroundColor: cs.surface,
        );

    return WillPopScope(
      onWillPop: () async {
        Get.dialog(kCloseAppDialog());
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: cs.primary,
          title: Text(
            'Lelia',
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
          builder: (con) => Stack(
            children: [
              //todo: put a warning here 'verify your email' (and dont let user do any request)
              Form(
                key: con.dataFormKey,
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  children: [
                    // todo: check constraints for fields
                    CustomField(
                      controller: con.name,
                      iconData: Icons.label,
                      hint: "اسم النقطة",
                      validator: (s) {
                        return validateInput(s!, 2, 100, "name");
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
                            hint: "الحي",
                            validator: (s) {
                              return validateInput(s!, 2, 50, "name");
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
                            hint: "الشارع",
                            validator: (s) {
                              return validateInput(s!, 2, 50, "name");
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
                        return validateInput(s!, 7, 7, "");
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
                        return validateInput(s!, 10, 12, "");
                      },
                      onChanged: (s) {
                        if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: CheckboxListTile(
                        value: con.available,
                        onChanged: (val) {
                          con.toggleAvailability(val!);
                        },
                        checkColor: cs.onPrimary,
                        activeColor: cs.primary,
                        title: Text(
                          "التواجد",
                          style: tt.titleMedium!.copyWith(color: cs.onBackground.withOpacity(0.6)),
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
                          con.setReportState(newVal!);
                        },
                        selectedValue: con.state,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12.0),
                      child: ListTile(
                        leading: Icon(Icons.location_searching, size: 30, color: cs.primary),
                        title: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            "احداثيات النقطة",
                            style: tt.titleMedium!.copyWith(
                              color: cs.onBackground.withOpacity(0.6),
                            ),
                          ),
                        ),
                        trailing: con.isLoading
                            ? CircularProgressIndicator()
                            : con.position == null
                                ? const Icon(Icons.close, color: Colors.red, size: 35)
                                : const Icon(Icons.task_alt, color: Colors.green, size: 35),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
                          child: Row(
                            children: [
                              ElevatedButton(
                                onPressed: () {
                                  con.getLocation(context);
                                },
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                                ),
                                child: Text(
                                  'حفظ',
                                  style: tt.titleMedium!.copyWith(color: cs.onPrimary),
                                ),
                              ),
                              SizedBox(width: 12),
                              Visibility(
                                visible: con.position != null,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Get.to(
                                      MapPage(
                                        latitude: con.position!.latitude,
                                        longitude: con.position!.longitude,
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                                  ),
                                  child: Text(
                                    'معاينة',
                                    style: tt.titleMedium!.copyWith(color: cs.onPrimary),
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
                        return validateInput(s!, 0, 255, "", canBeEmpty: true);
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
                              child: DottedBorder(
                                strokeWidth: 2.5,
                                color: cs.onBackground.withOpacity(0.6),
                                dashPattern: [10, 10],
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 30),
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.camera_alt,
                                          size: 40,
                                          color: cs.onBackground.withOpacity(0.6),
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
                                ),
                              ),
                            )
                          : Column(
                              children: [
                                CarouselSlider(
                                  items: [
                                    ...con.images
                                        .map(
                                          (image) => Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: GestureDetector(
                                              onTap: () {
                                                Get.dialog(
                                                  AlertDialog(
                                                    title: Text(
                                                      "عرض الصورة",
                                                      style: tt.titleLarge!.copyWith(color: cs.onSurface),
                                                    ),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          con.removeImage(image);
                                                          Get.back();
                                                        },
                                                        child: Text(
                                                          "حذف",
                                                          style: tt.titleMedium?.copyWith(color: cs.error),
                                                        ),
                                                      ),
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
                                                    content: InteractiveViewer(
                                                      child: Image.file(File(image.path)),
                                                    ),
                                                  ),
                                                );
                                              },
                                              child: Image.file(File(image.path)),
                                            ),
                                          ),
                                        )
                                        .toList(),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: GestureDetector(
                                        onTap: () {
                                          showPickPicSheet();
                                        },
                                        child: Container(
                                          //width: 100,
                                          //height: 150,
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
                                    ),
                                  ],
                                  options: CarouselOptions(
                                    enableInfiniteScroll: false,
                                    aspectRatio: 4 / 3,
                                    onPageChanged: (i, reason) => con.setPicIndex(i),
                                    viewportFraction: 1,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                AnimatedSmoothIndicator(
                                  activeIndex: con.picIndex,
                                  count: con.images.length + 1,
                                  effect: WormEffect(dotHeight: 9, dotWidth: 9, activeDotColor: cs.primary),
                                )
                              ],
                            ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0, bottom: 8, left: 4, right: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          con.submit();
                        },
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all<Color>(cs.primary),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: GetBuilder<HomeController>(builder: (con) {
                            return con.isLoadingSubmit
                                ? SpinKitThreeInOut(color: cs.onPrimary, size: 30)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'حفظ في الذاكرة',
                                        style: tt.titleLarge!.copyWith(color: cs.onPrimary),
                                      ),
                                      SizedBox(width: 12),
                                      Icon(
                                        Icons.save_alt,
                                        size: 40,
                                        color: cs.onPrimary,
                                      ),
                                    ],
                                  );
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        drawer: Drawer(
          backgroundColor: cs.background,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    GetBuilder<HomeController>(builder: (con) {
                      return con.isLoading
                          ? SpinKitPianoWave(color: cs.primary)
                          : UserAccountsDrawerHeader(
                              //todo: showing old data or not showing at all, add loading (is it solved?)
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
                      leading: const Icon(Icons.mobile_friendly),
                      title: Text("التقارير المحفوظة", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
                      onTap: () {
                        Get.to(() => LocalReportsView());
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.checklist_outlined),
                      title: Text("جميع تقاريري", style: tt.titleMedium!.copyWith(color: cs.onBackground)),
                      onTap: () {
                        Get.to(() => const AllReportsView());
                      },
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
                        hC.logout();
                      },
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'ليتيا® جميع الحقوق محفوظة',
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
