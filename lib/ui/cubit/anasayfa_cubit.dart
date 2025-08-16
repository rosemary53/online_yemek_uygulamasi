import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:online_yemek_uygulamasi/data/entity/yemekler.dart';
import 'package:online_yemek_uygulamasi/data/repository/begenilen_yemek_repo.dart';
import 'package:online_yemek_uygulamasi/data/repository/yemek_repo.dart';
import 'package:online_yemek_uygulamasi/ui/cubit/anasayfa_state.dart';

class AnasayfaCubit extends Cubit<AnasayfaState> {

  AnasayfaCubit() : super(AnasayfaState(yuklendiMi: true));

  var  yRepo = YemekRepo();
  var  byRepo = BegenilenYemekRepo();


  Future<void> yemekleriListele() async {
    emit(state.copyWith(yuklendiMi: true));
    var yemekListesi = await yRepo.yemekleriListele();
    var begenilenler = await byRepo.begenilenYemekListele();
    var begenilenYemekIdSet = begenilenler.map((y) => y.yemek_id).toSet();//yemek nesnesi map tipinde ve yemek.id özelliği dikkate alınmak isteniyor
    var begeniSayisi = await byRepo.begeniSayisi();
    emit(state.copyWith(
          yemekListesi: yemekListesi,
          gosterilecekListe: yemekListesi,//başlangıçta tüm liste olarak başlattım
          begenilenYemekIdSet: begenilenYemekIdSet,
          begeniSayisi: begeniSayisi,
          yuklendiMi: false,
    ));
  }

  Future<void> toggleBegeni(Yemekler yemek) async {
    if (state.begenilenYemekIdSet.contains(yemek.yemek_id)) {
      await byRepo.begenilenleriKaldir(yemek.yemek_id);
      final newSet = Set<String>.from(state.begenilenYemekIdSet)..remove(yemek.yemek_id);
      emit(state.copyWith(begenilenYemekIdSet: newSet));
    } else {
      await byRepo.begenilenlereEkle(
        yemek.yemek_id,
        yemek.yemek_adi,
        yemek.yemek_resim_adi,
        yemek.yemek_fiyat,
      );
      final newSet = Set<String>.from(state.begenilenYemekIdSet)..add(yemek.yemek_id);
      emit(state.copyWith(begenilenYemekIdSet: newSet));
    }
    var guncelBegeniSayisi = await byRepo.begeniSayisi();
    emit(state.copyWith(begeniSayisi: guncelBegeniSayisi));
  }

  Future<void> aramaYapiliyorMu(bool aramaDurumu) async{
    if(aramaDurumu){
      emit(state.copyWith(aramaYapiliyorMu: true));
    }
    else{
      //arama bittiğinde anasayfada filtreli liste kullanıldıgı için tekrar tümYemekler ekrana gelecek şekilde güncelledim
      emit(state.copyWith(aramaYapiliyorMu: false,aramaKelimesi: "",gosterilecekListe: state.yemekListesi));
    }
  }
  Future<void> aramaMetniDegisti (String aramaKelimesi) async{
    final filtreliListe = state.yemekListesi.where((yemek) {
      return yemek.yemek_adi.toLowerCase().contains(aramaKelimesi.toLowerCase());
    }).toList();
    emit(state.copyWith(gosterilecekListe:filtreliListe,aramaKelimesi: aramaKelimesi));
  }

  Future<void> seciliIcon(int numara) async{
    emit(state.copyWith(seciliIconNumarasi: numara));
    print("SeciliIcon metodu çalıştı:$numara");
  }
  //Sıralama Fonksiyonları

  //Düşük Fiyattan Yüksek Fiyata Göre Sırala
  Future<void> fiyataGoreSiralaDY() async{
    var siralanacakListe = [...state.yemekListesi];
    siralanacakListe.sort((ilkYemek, ikinciYemek) =>
      int.parse(ilkYemek.yemek_fiyat).compareTo(int.parse(ikinciYemek.yemek_fiyat))
   );
    emit(state.copyWith(gosterilecekListe: siralanacakListe));
  }
  //Yüksek Fiyattan Düşük FiyataGöre Sırala
  Future<void> fiyataGoreSiralaYD() async{
    var siralanacakListe = [...state.yemekListesi];
    siralanacakListe.sort((ilkYemek, ikinciYemek) =>
        int.parse(ikinciYemek.yemek_fiyat).compareTo(int.parse(ilkYemek.yemek_fiyat))
    );
    emit(state.copyWith(gosterilecekListe: siralanacakListe));
  }
  //AZ ye göre sırala
  Future<void> siralamaYapAZ() async{
    var siralanacakListe = [...state.yemekListesi];
    siralanacakListe.sort((ilkYemek, ikinciYemek) =>
        ilkYemek.yemek_adi.compareTo(ikinciYemek.yemek_adi)
    );
    emit(state.copyWith(gosterilecekListe: siralanacakListe));
  }
  //ZA ya göre sırala
  Future<void> siralamaYapZA() async{
    var siralanacakListe = [...state.yemekListesi];
    siralanacakListe.sort((ilkYemek, ikinciYemek) =>
        ikinciYemek.yemek_adi.compareTo(ilkYemek.yemek_adi)
    );
    emit(state.copyWith(gosterilecekListe: siralanacakListe));
  }
}
