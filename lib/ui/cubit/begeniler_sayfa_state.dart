import '../../data/entity/yemekler.dart';

class BegenilerSayfaState{
  final List<Yemekler> yemekListe;

  BegenilerSayfaState({
    this.yemekListe = const []
  });

  BegenilerSayfaState copyWith({
    List<Yemekler>? yemekListe
  }){
    return BegenilerSayfaState(
      yemekListe: yemekListe ?? this.yemekListe
    );
  }
}