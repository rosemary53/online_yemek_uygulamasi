// Örnek SepetSayfaState tanımı
import '../../data/entity/sepet_yemekler.dart';

class SepetSayfaState {
  final List<SepetYemekler> sepetYemekListe;

  SepetSayfaState({this.sepetYemekListe = const []});

  SepetSayfaState copyWith({List<SepetYemekler>? sepetYemekListe}) {
    return SepetSayfaState(
      sepetYemekListe: sepetYemekListe ?? this.sepetYemekListe,
    );
  }
}