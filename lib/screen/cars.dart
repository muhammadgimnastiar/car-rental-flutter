import 'package:flutter/material.dart';
import 'package:rental_santuy/data/vehicle_data.dart' as vehicles;
import 'package:rental_santuy/data/keys.dart';
import 'package:rental_santuy/screen/login.dart';
import 'package:rental_santuy/style/colors.dart';
import 'package:rental_santuy/style/text.dart';
import 'package:rental_santuy/widget/card.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/modal.dart';

class Cars extends StatefulWidget {
  final SharedPreferences sharedPrefs;
  const Cars(this.sharedPrefs, {Key? key}) : super(key: key);

  @override
  State<Cars> createState() => _CarsState();
}

class _CarsState extends State<Cars> {
  String title = "Cars";
  bool isFavorite = true;
  String nama = "";
  String nim = "";
  String username = "";

  void getNamaFromLocal() async {
    nama = widget.sharedPrefs.getString(Keys.nama) ?? Login.nama;
    nim = widget.sharedPrefs.getString(Keys.nim) ?? Login.nim;
    username = widget.sharedPrefs.getString(Keys.username) ?? Login.username;

    setState(() {});
  }

  @override
  void initState() {
    getNamaFromLocal();
    super.initState();
  }

  List<Map<String, dynamic>> carsList = vehicles.VehicleData.Cars;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(
            Icons.arrow_back_ios,
            color: MyColors.blackSld,
          ),
        ),
        title: Center(child: TextLarge(title)),
        actions: [
          InkWell(
            onTap: (() async {
              showFloatingModalBottomSheet(
                context: context,
                builder: (context) => ModalFit(
                  nama: nama,
                  nim: nim,
                  username: username,
                  sharedPrefs: widget.sharedPrefs,
                ),
              );
            }),
            child: Image.asset(
              'lib/assets/avatars/Avatar.png',
              width: 32,
            ),
          ),
          const SizedBox(
            width: 24,
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: carsList.length,
            itemBuilder: (context, index) {
              return CardRental(
                carsList[index]['name'],
                carsList[index]['price'],
                widget.sharedPrefs,
                uid: carsList[index]['uid'],
                image: carsList[index]['image'],
                color: carsList[index]['color'],
              );
            }),
      ),
    );
  }
}
