// food_state.dart
import 'package:flutter/cupertino.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';

class AnasayfaState {
  //State de istediğimiz tipte verileri tutabiliriz
  final bool yuklendiMi;
  final List<Yemekler> yemekListesi;
  final Set<String> begenilenYemekIdSet;
  final int begeniSayisi;

  // Arama durumu için yeni değişkenler
  final bool aramaYapiliyorMu;
  final String aramaKelimesi;
  final List<Yemekler> gosterilecekListe;

  //Bottom Bar için değişkenler
  final int seciliIconNumarasi; // <-- Yeni eklenen kısım

  AnasayfaState({
    this.yuklendiMi = false,
    this.yemekListesi = const [],
    this.begenilenYemekIdSet = const {},
    this.begeniSayisi = 0,
    this.aramaYapiliyorMu = false,
    this.aramaKelimesi ="",
    this.seciliIconNumarasi = 0,
    this.gosterilecekListe = const []
  });

  // Durumu güncellemek için bir kopya oluşturan yardımcı fonksiyon.
  AnasayfaState copyWith({
    bool? yuklendiMi ,
    List<Yemekler>? yemekListesi,
    Set<String>? begenilenYemekIdSet,
    int? begeniSayisi,
    bool? aramaYapiliyorMu,
    String? aramaKelimesi,
    int? seciliIconNumarasi, // <-- Yeni eklenen kısım
    List<Yemekler>? gosterilecekListe
  }) {
    return AnasayfaState(
      yuklendiMi:  yuklendiMi ?? this.yuklendiMi,
      yemekListesi: yemekListesi ?? this.yemekListesi,
      begenilenYemekIdSet: begenilenYemekIdSet ?? this.begenilenYemekIdSet,
      begeniSayisi: begeniSayisi ?? this.begeniSayisi,
      aramaYapiliyorMu:  aramaYapiliyorMu ?? this.aramaYapiliyorMu,
      aramaKelimesi: aramaKelimesi ?? this.aramaKelimesi,
      seciliIconNumarasi: seciliIconNumarasi ?? this.seciliIconNumarasi,
      gosterilecekListe: gosterilecekListe ?? this.gosterilecekListe
    );
  }
}