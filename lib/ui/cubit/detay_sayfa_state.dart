import 'package:online_yemek_uygulamasi/data/entity/sepet_yemekler.dart';

class DetaySayfaState{
  final int siparisAdeti;
  final List<SepetYemekler> sepetYemekler;

  DetaySayfaState({
    this.siparisAdeti = 0,
    this.sepetYemekler = const [],
  });

  DetaySayfaState copyWith({
    //Parametreler
    int? siparisAdeti,
    List<SepetYemekler>? sepetYemekler
  }){
     return DetaySayfaState(
         siparisAdeti: siparisAdeti ?? this.siparisAdeti,
         sepetYemekler: sepetYemekler ?? this.sepetYemekler
     );
   }
}