import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:online_yemek_uygulamasi/data/entity/sepet_yemekler.dart';
import 'package:online_yemek_uygulamasi/data/entity/sepet_yemekler_cevap.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler_cevap.dart';

import '../../sqlite/veritabani_yardimcisi.dart';

class YemekRepo{
  //Repository de genel olarak CRUD işlemleri olmalıdır.

  List<Yemekler> parseYemekler(String cevap){
    return YemeklerCevap.fromJson(jsonDecode(cevap)).yemekler;
  }

  Future <List<Yemekler>> yemekleriListele() async{
    var url ="http://kasimadalan.pe.hu/yemekler/tumYemekleriGetir.php";
    var cevap = await Dio().get(url);

    print("Yemekler Yüklendi Mi :$cevap");
    return parseYemekler(cevap.data.toString());
  }

  //Sepete Yemek Ekle
  Future <void> sepeteYemekEkle(Yemekler yemekNesnesi,String yemek_siparis_adet,String kullanici_adi) async {
    var url =  "http://kasimadalan.pe.hu/yemekler/sepeteYemekEkle.php";
    var sepeteEklenenVeri ={
      "yemek_adi": yemekNesnesi.yemek_adi,
      "yemek_resim_adi" : yemekNesnesi.yemek_resim_adi,
      "yemek_fiyat": yemekNesnesi.yemek_fiyat,
      "yemek_siparis_adet": yemek_siparis_adet,
      "kullanici_adi": kullanici_adi
    };
    var cevap = await Dio().post(url,data: FormData.fromMap(sepeteEklenenVeri));
    print("Sepete yemek eklendi :${cevap}");
  }
  //Geriye SepetYemekler tipinde bir liste döndürecek
  List<SepetYemekler> parseSepetYemekler(String cevap) {
    if (cevap.trim().isEmpty) { // boşlukları da temizle
      return [];
    }
    return SepetYemeklerCevap.fromJson(jsonDecode(cevap)).sepet_yemekler;
  }

  //Webservis kullanıcı adına ait sepetteki yemekleri listeleyecek
  Future<List<SepetYemekler>> sepetYemekListele(String kullanici_adi) async{
    var url = "http://kasimadalan.pe.hu/yemekler/sepettekiYemekleriGetir.php";
    var veri = {"kullanici_adi" :kullanici_adi};

    var cevap = await Dio().post(url,data: FormData.fromMap(veri));
    return parseSepetYemekler(cevap.data.toString());
  }

  //Sepetteki Yemekleri Sil
  Future <void>  sepetYemekSil(String sepet_yemek_id,String kullanici_adi) async{
    var url = "http://kasimadalan.pe.hu/yemekler/sepettenYemekSil.php";
    var silinenVeri = {"sepet_yemek_id":sepet_yemek_id,"kullanici_adi":kullanici_adi};
    var cevap = await Dio().post(url,data: FormData.fromMap(silinenVeri));
    print("Veri silindi mi : $cevap");
  }

}