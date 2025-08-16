import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:sqflite/sqflite.dart';

import '../../sqlite/veritabani_yardimcisi.dart';

class BegenilenYemekRepo{

  //Sqlite İle Begenilen Yemekleri Ekle
  Future<void> begenilenlereEkle(String api_yemek_id,String yemek_ad,String yemek_resim_adi,String yemek_fiyat) async{
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    var begenilenYemek = Map<String,dynamic>();//Tabloların alan adları string tipinde alacağı değerler değişebilir
    begenilenYemek["api_yemek_id"] =api_yemek_id;
    begenilenYemek["yemek_adi"] = yemek_ad;
    begenilenYemek["yemek_resim_adi"] = yemek_resim_adi;
    begenilenYemek["yemek_fiyat"] = yemek_fiyat;
    int sonuc = await db.insert("begenilen_yemek", begenilenYemek);
    print("Begenilere ekleme sonuc : $sonuc");
  }

  //Begenilen Yemekleri Listele
  Future<List<Yemekler>> begenilenYemekListele() async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    List<Map<String, dynamic>> begenilenYemekListesi = await db.rawQuery("SELECT * FROM begenilen_yemek");

    return List.generate(begenilenYemekListesi.length, (index) {
      var satir = begenilenYemekListesi[index];

      // SQLite'dan gelen int tipte değerleri String'e çeviriyoruz
      String apiYemekIdStr = satir["api_yemek_id"].toString();
      String yemekFiyatStr = satir["yemek_fiyat"].toString();

      return Yemekler(
        yemek_id: apiYemekIdStr,
        yemek_adi: satir["yemek_adi"] as String,
        yemek_resim_adi: satir["yemek_resim_adi"] as String,
        yemek_fiyat: yemekFiyatStr,
      );
    });
  }

  //Begenilenelri kaldır

  Future<void> begenilenleriKaldir(String api_yemek_id) async {
    var db = await VeritabaniYardimcisi.veritabaniErisim();
    int sonuc = await db.delete(
      "begenilen_yemek",
      where: "api_yemek_id = ?",
      whereArgs: [api_yemek_id],
    );
    print("Begenilerden kaldirma sonucu: $sonuc");
  }

  // Begeni sayısını tablodan cek COUNT ile
 Future<int> begeniSayisi() async{
   var db = await VeritabaniYardimcisi.veritabaniErisim();
   final sonuc = await db.rawQuery("SELECT COUNT(*) as count FROM begenilen_yemek");
   int count = Sqflite.firstIntValue(sonuc) ?? 0;
   return count;
 }
}