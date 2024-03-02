import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lelia/controllers/home_controller.dart';
import 'package:lelia/controllers/theme_controller.dart';
import 'package:lelia/views/components/custom_dropdown.dart';
import 'package:lelia/views/components/custom_field.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeController tC = Get.find();
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
      ),
      backgroundColor: cs.background,
      body: GetBuilder<HomeController>(
        init: HomeController(),
        builder: (con) => Form(
          key: con.dataFormKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: [
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
              CheckboxListTile(
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
              CustomField(
                controller: con.notes,
                //iconData: Icons.note_alt_sharp,
                hint: "ملاحظات الزبون",
                lines: 3,
                validator: (s) {
                  return validateInput(s!, 0, 1100, "");
                },
                onChanged: (s) {
                  if (con.buttonPressed) con.dataFormKey.currentState!.validate();
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    con.submit();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'حفظ في الذاكرة',
                        style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.save, size: 28),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: ElevatedButton(
                  onPressed: () {
                    con.getLocation();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'locate',
                        style: tt.headlineSmall!.copyWith(color: cs.onPrimary),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.save, size: 28),
                    ],
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
          ],
        ),
      ),
    );
  }
}

String? validateInput(String val, int min, int max, String type, {String pass = "", String rePass = ""}) {
  //todo: localize
  if (val.trim().isEmpty) return "لا يمكن أن يكون فارغ";

  if (type == "username") {
    if (!GetUtils.isUsername(val)) return "not a valid user name";
  }
  if (type == "email") {
    if (!GetUtils.isEmail(val)) return "not a valid email";
  }
  if (type == "phone") {
    if (!GetUtils.isPhoneNumber(val)) return "not a valid phone";
  }
  if (val.length < min) return "value cant be smaller than $min";

  if (val.length > max) return "value cant be greater than $max";

  if (pass != rePass) return "passwords don't match".tr;

  return null;
}
